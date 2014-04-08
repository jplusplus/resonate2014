# Encoding: utf-8

class Navigation

	constructor: () ->
		@uis = 
			brand           : $(".navbar-brand")
			header          : $(".header")
			header_chapters : $(".header .chapters")
			title           : $(".main_title")
			logo_intro      : $("img.logo")
			media           : $(".illustration, .iframe")
			iframes         : $(".iframe")
		@media        = {}
		@titlesOffset = []
		activeTarget  = undefined

		@relayout()

		# show title image when loaded
		image = $("<img/>").attr("src", @uis.title.css("background-image").slice(4, -1).replace(/"/g, ""))
		image.load(@showImage(@uis.title))

		# bind events
		lazy_relayout = _.debounce(@relayout, 10)
		$(window).resize(lazy_relayout)
		window.onscroll = @onScroll
		$('.bookmark a').click(@onAncreClick)

	relayout: =>
		main_page_height = $(window).height() - @uis.title.offset().top
		@uis.title.css 'height', main_page_height
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
		return (e) ->
			body = $("<div/>").addClass("body")
			if media.data("src")?
				media.find(".body").remove()
				media.prepend(body)
				body.css
					"background-image" : "url(#{media.data("src")})"
			if media.data("position")?
				body.css
					"background-position": media.data("position")
			media.css
				"opacity" : 1
			$('body').each ->
				$spy = $(this).scrollspy('refresh')

	showIframe: (media, iframe) =>
		return (e) ->
			media.css("opacity", 1)
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
