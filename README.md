# Mongo Dungeon

The point of this is so we can practice actually running mongo commands in an authentic incident. Because we don't want to actually wait for incidents to practice our skills, we're going to simulate things happening in mongo.

The following is a list of situations that we want to practice running through:

- mongo primary is swamped with writes, we want to manually step it down
- mongo version needs to be upgraded, so we need set up a new replicaset and transfer over the oplog (or something...still need to confirm the procedure here)
- we have an unindexed collection that needs indexing, but we don't want to run it in the foreground (and maybe it's too big to even run safely in the background). So we build a background index on one secondary, then the other, then step down the primary and create the index once it's a secondary.
- we need to restart the entire mongo process, but with the flag to not build the index (this is version dependent, so maybe we won't keep this scenario)
- etc. 

## Architecture

We would usually run the mongodb_exporter in the same VM as the mongo process, but since we're going to try and use containers, we're just going to have one of the containers run the exporter, and point that at the container running the mongod process.

Eventually, we'll have a replicaset with 3 mongo containers, along with 3 separate mongodb_exporter containers, for a total of 6.

We will also have one prometheus container that will communicate with the exporters, plus one grafana container using prometheus as a data source, and which exposes a web interface.

TOTAL CONTAINERS: 8

Eventually, we may want some sort of application server that fires off reads/writes and can be set to trigger some of the scenarios above on a predictable schedule (eg, we want to simulate a traffic spike to mongo, then see what happens in grafana and manually fail over to a secondary), but the first goal is just to get the replicasets reporting metrics through to grafana.
