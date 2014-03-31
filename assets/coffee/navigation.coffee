# Encoding: utf-8

class Navigation

	constructor: () ->
		@uis = 
			header     : $(".navbar")
			title      : $(".main_title")
			logo_intro : $("img.logo")

		@relayout()

		$(".illustration").each (e, i) ->
			$(this).css
				"background-image" : "url(#{$(this).data("src")})"

		$(window).on("resize", @relayout)
		window.onscroll = @onScroll

	relayout: =>
		logo_height = $(window).height() - @uis.title.offset().top - 105
		@uis.logo_intro.css
			height: logo_height

	onScroll: (e) =>
		@uis.header.toggleClass("reverse", $(document).scrollTop() == 0)

# EOF
