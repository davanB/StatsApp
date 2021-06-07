# StatsApp

To start from source code:

  * Start postgres with correct credentials from dev.exs
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

From docker image:

  * Ensure docker is installed (I have version 3.3.3)
  * Run `docker compose up --build`

## Bugs

- When downloading a file from the live view, I redirect to a controller since you can only download files from regular controllers. The Phoenix function will automatically send a response back and will case the live view to hang. I am not sure how to fix this.

## Possible improvments

- If the number of players grows much larger it might be good to add an index on `player` to make searching/filtering by name faster.
- I choose to order by stats in the live view and not using the database. The reason being is I think this will scale much better by putting less strain on the DB. If the number of users rises considerably you can just deploy another instance of the app instead of worrying about the database.
- There are no unit tests for the live view. I know there are functions to send events to the live view to test for side effects but all the functionality is ordering by stats so checking for side effects will mean parsing the HTML and making sure the records are in the right order. Not impossible but time consuming but brittle. If the HTML changes, it will break the tests.
- Ordering by multiple stats at the same time. This is difficult since we have to maintain a queue of what the users selects to order by. The order that the user selects the columns is important.
- Publish the docker image to docker hub to share.