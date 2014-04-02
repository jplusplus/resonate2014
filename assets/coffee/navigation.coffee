# Encoding: utf-8

class Navigation

	constructor: () ->
		@uis = 
			header          : $(".header")
			header_chapters : $(".header .chapters")
			title           : $(".main_title")
			logo_intro      : $("img.logo")
			titles          : $(".anchor[id]")
			illustrations   : $(".illustration")
		@media        = {}
		@titlesOffset = []
		activeTarget  = undefined

		@relayout()

		# bind events
		$(window).on("resize", @relayout)
		window.onscroll = @onScroll
		$('.bookmark a').click(@onAncreClick)
		$('body').scrollspy({ target: '.bookmark', offset:300 })

	relayout: =>
		that = this
		# logo
		logo_height = $(window).height() - @uis.title.offset().top - 105
		logo_width  = $(window).width() - 50
		@uis.logo_intro.css
			height: Math.min(logo_height, logo_width)
		# media
		@media        = {}
		@titlesOffset = []
		@uis.illustrations.each((e, i) -> that.media[$(this).offset().top] = $(this))
		# scrollbar
		$('body').scrollspy("refresh")

	onScroll: =>
		# toggle header style
		@toggleHeaderStyle($(document).scrollTop() == 0)
		#show media
		window_position = $(document).scrollTop() + $(window).height()
		for offset, media of @media
			if window_position - 100 >= offset
				media.css
					"background-image" : "url(#{media.data("src")})"
				delete @media[offset]

	toggleHeaderStyle: (reverse) => @uis.header.toggleClass("reverse", reverse)

	onAncreClick: (e) =>
		ancre = $(e.currentTarget)
		id = ancre.attr("href")
		offset = if $(id).offset() then $(id).offset().top - 50 else 0
		$('html, body').animate({scrollTop: offset}, 'slow')
		return false

# EOF
