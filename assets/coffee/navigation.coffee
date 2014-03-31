# Encoding: utf-8

class Navigation

	constructor: () ->
		@uis = 
			header     : $(".navbar")
			title      : $(".main_title")
			logo_intro : $("img.logo")
		@media = {}

		@relayout()

		$(window).on("resize", @relayout)
		window.onscroll = @onScroll

	relayout: =>
		that = this
		# logo
		logo_height = $(window).height() - @uis.title.offset().top - 105
		@uis.logo_intro.css
			height: logo_height
		# media
		$(".illustration").each (e, i) ->
			that.media[$(this).offset().top] = $(this)

	onScroll: =>
		# toggle header style
		@uis.header.toggleClass("reverse", $(document).scrollTop() == 0)
		#show media
		window_position = $(document).scrollTop() + $(window).height() - 100
		for offset, media of @media
			if window_position >= offset
				media.css
					"background-image" : "url(#{media.data("src")})"
				delete @media[offset]

# EOF
