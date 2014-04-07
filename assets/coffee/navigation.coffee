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
		@media        = {}
		@titlesOffset = []
		activeTarget  = undefined

		@relayout()

		# show title image when loaded
		image = $("<img/>").attr("src", @uis.title.css("background-image").slice(4, -1).replace(/"/g, ""))
		image.load(@showImage(@uis.title))

		# bind events
		lazy_relayout = _.debounce(@relayout, 300)
		$(window).resize(lazy_relayout)
		window.onscroll = @onScroll
		$('.bookmark a').click(@onAncreClick)
		$('body').scrollspy({ target: '.bookmark', offset:300 })

	relayout: =>
		if @_width == $(window).width()
			return false
		@_width = $(window).width()
		that = this
		# main page
		main_page_height = $(window).height() - @uis.title.offset().top
		@uis.title.css 'height', main_page_height
		# media
		@media        = {}
		@titlesOffset = []
		@uis.media.each((e, i) -> that.media[$(this).offset().top] = $(this))

	onScroll: =>
		# toggle header style
		@toggleHeaderStyle($(document).scrollTop() == 0)
		#show media
		window_position = $(document).scrollTop() + $(window).height()
		for offset, media of @media
			if window_position + 200 >= offset
				if media.hasClass("illustration")
					# show picture
					image = $("<img />").attr("src", media.data("src"))
					image.load(@showImage(media, image))
				else
					# show iframe
					iframe = $("<iframe></iframe>").attr("src", media.data("src")).attr("frameborder", 0)
					media.html(iframe)
					iframe.attr("width", "100%")
					iframe.attr("height", iframe.width() /parseInt(media.data("ratio")))
					iframe.load(@showIframe(media, iframe))
				delete @media[offset]

	showImage: (media, image) =>
		return (e) ->
			body = $("<div/>").addClass("body")
			if media.parents(".article").length
				body.css "height", image.get(0).naturalHeight/image.get(0).naturalWidth * media.width()
			if media.height() <= 0
				if media.attr("width")? and image?
					body.css "height", image.get(0).naturalHeight/image.get(0).naturalWidth * media.attr("width")
					body.css "width", media.attr("width")
			if media.data("src")?
				media.find(".body").remove()
				media.prepend(body)
				body.css
					"background-image" : "url(#{media.data("src")})"
			media.css
				"opacity" : 1

	showIframe: (media, iframe) =>
		return (e) ->
			media.css("opacity", 1)

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
