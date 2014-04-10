# Encoding: utf-8
# Project : Resonate 2014
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU General Public License
# -----------------------------------------------------------------------------
# Creation : 26-Mar-2014
# Last mod : 10-Apr-2014
# -----------------------------------------------------------------------------
# This file is part of Resonate2014.
# 
#     Resonate2014 is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     Resonate2014 is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with Resonate2014.  If not, see <http://www.gnu.org/licenses/>.

class Navigation

	constructor: () ->
		@uis = 
			brand           : $(".navbar-brand")
			header          : $(".header")
			header_chapters : $(".header .chapters")
			title           : $(".main_title")
			title_body      : $(".main_title .lead")
			logo_intro      : $("img.logo")
			media           : $(".illustration, .iframe")
			iframes         : $(".iframe")
		@media        = {}
		@titlesOffset = []
		activeTarget  = undefined

		@relayout()

		# show title image when loaded
		image = $("<img/>").attr("src", @uis.title.data("src"))
		image.load(@showImage(@uis.title))

		# bind events
		lazy_relayout = _.debounce(@relayout, 10)
		$(window).resize(lazy_relayout)
		window.onscroll = @onScroll
		$('.bookmark a, .navbar-header a').click(@onAncreClick)
		$('.navbar-collapse').on('show.bs.collapse',   => @toggleHeaderStyle(false))
		$('.navbar-collapse').on('hidden.bs.collapse', => @toggleHeaderStyle($(document).scrollTop() == 0))

	relayout: =>
		main_page_height = $(window).height() - @uis.title.offset().top
		@uis.title.css 'height', main_page_height
		title_body_offset = main_page_height - @uis.title_body.height() - 50
		@uis.title_body.css
			top : if main_page_height / 2 > title_body_offset then title_body_offset else ""
		# main page
		if @_width == $(window).width()
			return false
		@_width = $(window).width()
		that = this
		# set media height to allow scroll
		@uis.iframes.each ->
			$(this).css("height", $(this).width() /parseFloat($(this).data("ratio")))
		@uis.media.each ->
			$(this).css("height", $(this).width() / parseFloat($(this).data("ratio")))
		# media
		@media        = {}
		@titlesOffset = []
		$('body').scrollspy({ target: '.bookmark', offset:300 })
		@uis.media.each((e, i) -> that.media[$(this).offset().top] = $(this))

	onScroll: =>
		# toggle header style
		@toggleHeaderStyle($(document).scrollTop() == 0)
		#show media
		window_position = $(document).scrollTop() + $(window).height()
		for offset, media of @media
			if window_position + 300 >= offset
				if media.hasClass("illustration")
					# show picture
					image = $("<img />").attr("src", media.data("src"))
					image.load(@showImage(media, image))
				else
					# show iframe
					iframe = $("<iframe></iframe>")
						.attr("src"        , media.data("src"))
						.attr("frameborder", 0)
						.attr("width"      , "100%")
						.attr("height"     , "100%")
					media.html(iframe)
					iframe.load(@showIframe(media, iframe))
				delete @media[offset]

	showImage: (media, image) =>
		media.addClass("loading")
		loader = $("<div class=\"loader\"/>")
		media.prepend(loader)
		body = $("<div/>").addClass("body")
		if media.data("src")?
			media.find(".body").remove()
			media.prepend(body)
		if media.data("position")?
			body.css
				"background-position": media.data("position")
		return (e) ->
			if media.data("src")?
				body.css
					"background-image" : "url(#{media.data("src")})"
			setTimeout(->
				media.removeClass("loading")
				setTimeout(->
					loader.remove()
				, 500)
			, 100)
			$('body').each ->
				$spy = $(this).scrollspy('refresh')

	showIframe: (media, iframe) =>
		loader = $("<div class=\"loader\"/>")
		media.prepend(loader)
		media.addClass("loading")
		return (e) ->
			media.removeClass("loading")
			setTimeout(->
				loader.remove()
			, 500)
			$('body').each ->
				$spy = $(this).scrollspy('refresh')

	toggleHeaderStyle: (reverse) =>
		if reverse
			@uis.brand.find("span").addClass("hidden")
			@uis.header.addClass("reverse")
		else
			@uis.brand.find("span").removeClass("hidden")
			@uis.header.removeClass("reverse")

	onAncreClick: (e) =>
		ancre = $(e.currentTarget)
		id = ancre.attr("href")
		offset = if $(id).offset() then $(id).offset().top - @uis.header.outerHeight() else 0
		$('html, body').animate({scrollTop: offset}, 'slow')
		return false

# EOF
