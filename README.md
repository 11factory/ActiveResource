# ActiveResource
ActiveResource for IPhone is an implementation of the ActiveResource RAILS framework for mapping RESTful resources as models.

# Implemented features

- findById
- findAll
- save

# Sample
	MyRestResource.site = @"http://somewhere.com/resources/";
	MyRestResource.representation = @"application/json";
	NSArray *myRestResources = [MyRestResource findAll];
