# OpenLDES Demo

This demo will start an OpenLDES server and a workbench, which will add events to the server.
These events originate from the parking availability data from the city of Ghent.

Every 2 minutes, the pipeline of the workbench will check the availability of parking spots in
Ghent, will transform the data into the Mobivis format, and will send the events to the OpenLDES
server.

## Run the demo

```bash
docker compose up -d --wait
```

This will start a Postgres database, the OpenLDES server, and the workbench.

Once all containers are up, you can start setting up the LDES server and workbench.

## Setting up the LDES server

You create a new LDES stream by posting a request to the administration endpoint of the OpenLDES
server.

```bash
# define the LDES
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams" -d "@./server/occupancy.ttl"
# Check that the LDES is created:
curl -H "content-type: text/turtle" "http://localhost:8080/occupancy"
```

Then, we add four views to the LDES stream:

* One view that shows the occupancy by page
* One view that shows the occupancy by time
* One view that shows the occupancy by location
* One view that shows the occupancy by parking

```bash
# define the views
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams/occupancy/views" -d "@./server/occupancy.by-page.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams/occupancy/views" -d "@./server/occupancy.by-time.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams/occupancy/views" -d "@./server/occupancy.by-location.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams/occupancy/views" -d "@./server/occupancy.by-parking.ttl"
# Check that the views are created:
curl -H "content-type: text/turtle" "http://localhost:8080/occupancy"
```

## Setting up the workbench

We add a pipeline that will poll for JSON data from the city of Ghent, converts this to RDF,
transforms the RDF to Mobivis, generates versioned objects, and sends them to the LDES server.

```bash
curl -X POST -H "content-type: application/yaml" http://localhost:8081/admin/api/v1/pipeline --data-binary @./workbench/occupancy-pipeline.yml
# Check that the pipeline is created:
curl -H "content-type: text/turtle" "http://localhost:8081/admin/api/v1/pipeline"
```

## Run all at once

```bash
docker compose up -d --wait
# define the LDES
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams" -d "@./server/occupancy.ttl"
# Check that the LDES is created:
curl -H "content-type: text/turtle" "http://localhost:8080/occupancy"
# define the views
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams/occupancy/views" -d "@./server/occupancy.by-page.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams/occupancy/views" -d "@./server/occupancy.by-time.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams/occupancy/views" -d "@./server/occupancy.by-location.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:8080/admin/api/v1/eventstreams/occupancy/views" -d "@./server/occupancy.by-parking.ttl"
# Check that the views are created:
curl -H "content-type: text/turtle" "http://localhost:8080/occupancy"
curl -X POST -H "content-type: application/yaml" http://localhost:8081/admin/api/v1/pipeline --data-binary @./workbench/occupancy-pipeline.yml
# Check that the pipeline is created:
curl -H "content-type: text/turtle" "http://localhost:8081/admin/api/v1/pipeline"
```
