# ActiveResource
ActiveResource for IPhone is an implementation of the ActiveResource RAILS framework for mapping RESTful resources as models.

# Implemented features

- findById
- findAll
- findBy[any property]
- findAllBy[any property]
- save

# Sample
	MyRestResource.site = @"http://somewhere.com/resources/";
	MyRestResource.representation = @"application/json";
	NSArray *myRestResources = [MyRestResource findAll];

# License
	Copyright 2011 ut7

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
