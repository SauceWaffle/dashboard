window.app.ports.initPhotoSlideshow.subscribe(function(incoming) {
  window.CHESLIDESHOW = (function () {
    console.log(incoming)
  	var numSlides = incoming,
  		currentSlideIndex = 0,
      newSlideIndex = 0,
  		running = false,
  	 	slideSelector = document.getElementsByClassName('che-slideshow-slide'),
  		indicatorSelector = document.getElementsByClassName('slideshow-indicator'),
  		currentSlide,
  		newSlide,
  		mode;

  	function animateSlides (newMode) {
  		// prevents function from running while an animation is active
  		if (running) {
  			return false;
  		}
  		running = true;

  		//define target slides factoring in passed-in mode argument
  		mode = newMode;
  		setTargets(newMode);

  		// set indicators to next state
  		indicatorSelector[currentSlideIndex].classList.add('inactive-indicator');
  		indicatorSelector[newSlideIndex].classList.remove('inactive-indicator');

  		//set staging position
  		newSlide.style.left = mode === 'prev' ? '-100%' : '100%';
  		currentSlide.style.left = '0%';

  		newSlide.classList.remove("inactive");

  		//begins both animations
      if (incoming > 1) {
    		animate(newSlide);
    		animate(currentSlide);
      }
  	}

  	// defines target slides according to direction of animation
  	function setTargets() {
  		// get the index of the next slide. hard reset to 0 or numSlides (-1) so slideshow can loop back
  		if (mode === "prev") {
  			newSlideIndex = slideSelector[currentSlideIndex - 1] === undefined ? (numSlides - 1) : currentSlideIndex - 1;
  		} else {
  			newSlideIndex = slideSelector[currentSlideIndex + 1] === undefined ? 0 : currentSlideIndex + 1;
  		}

  		currentSlide = slideSelector[currentSlideIndex];
  		newSlide = slideSelector[newSlideIndex];
  	}

  	function animate (slide) {
  		var i = 0;

  		// animation interval
  		var animationInt = setInterval(function(){
  			//animate one tick according to direction
  			slide.style.left = mode === 'prev' ? ( parseInt(slide.style.left) + 2 ) + "%"
  												: ( parseInt(slide.style.left) - 2 ) + "%";

  			i++;
  			if(i >= 50) {
  				stopAnimation();
  			}
  		}, 7);

  		// clears interval, returns all elements to a nominal state
  		function stopAnimation () {
  			currentSlide.classList.add('inactive');
  			newSlide.style.left = '0%';
  			clearInterval(animationInt);
  			currentSlideIndex = newSlideIndex;
  			running = false;
  		}
  	}

  	// expose the private animate function & call with appropriate argument
  	return {
  		nextSlide: function () {
  			animateSlides('next');
  		},
  		prevSlide: function () {
  			animateSlides('prev');
  		}
  	};
  })();

  var prevArrow = document.getElementsByClassName('slideshow-left-control')[0];
  var nextArrow = document.getElementsByClassName('slideshow-right-control')[0];

      prevArrow.addEventListener('click', window.CHESLIDESHOW.prevSlide);
      nextArrow.addEventListener('click', window.CHESLIDESHOW.nextSlide);

  if (!window.slideshow)
    window.slideshow = setInterval(function(){ window.CHESLIDESHOW.nextSlide() },5000);

})


window.app.ports.slidePhotosLeft.subscribe(function(incoming) {
  var photosDiv = document.getElementById('photoSlider')

  if (photosDiv.scrollLeft >= 0) {
    photosDiv.style.webkitTransform = "translateX(0)";
    photosDiv.style.mozTransform = "translateX(0)";
    photosDiv.style.transform = "translateX(0)";
  }
})

window.app.ports.slidePhotosRight.subscribe(function(incoming) {
  var photosDiv = document.getElementById('photoSlider')

  //if (photosDiv.style.right != "") {
    photosDiv.style.webkitTransform = "translateX(-49%)";
    photosDiv.style.mozTransform = "translateX(-49%)";
    photosDiv.style.transform = "translateX(-49%)";
  //}
})
