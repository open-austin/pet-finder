# Scrape Information

## Search

Base URL: http://www.petharbor.com/results.asp

**URL Parameters**

* searchtype - LOST
* friends - 1
* samaritans - 1
* nosuccess - 0
* rows - 1000 *(can be arbitrarily increased so don’t have to deal with pagination, currently ~1000 animals in system)*
* imght - 120
* imgres - thumb
* view - sysadm.v_animal
* shelterlist - %27ASTN%27
* atype - cat, dog
* page - 1
* where - 
	* type\_x     
		x = CAT, DOG
	* gender\_x     
		x = m, f (male, female)
	* size\_x          
		x = s, m, l (small, medium, large)
	* age\_x          
		x = y, o (young < 1 year, old > 1 year)
	* color\_x          
		x = b, br, w (black, brown, white)
	* breed\_x          
		x = breed name with spaces replaced with %20
		
		[Cat breed names](cat_breeds.md)

		[Dog breed names](dog_breeds.md)

**Data to scrape and save**

* Name
* ID from shelter
* Gender
* Color
* Breed - can be split into primary and secondary
* Age - can be split into years, months and days
* Found date




## Pictures

Base URL: http://www.petharbor.com/get_image.asp

**URL Parameters**

* RES - thumb
* ID - from search scrape
* LOCATION - ASTIN
