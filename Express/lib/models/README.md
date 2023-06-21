# Models

This folder will hold all your app's models. Models are what are used for interacting with the database. Any interaction with a database should go through a model. A general convention with models is that their filenames are capitalized and singular (e.g. `User.js`).

Models manage our data. They are responsible for the shape of our data and retrieving that data from a data store.

The model will then expose an interface to the rest of the application. Any other file doesn't need to concern itself with how the data is managed.
