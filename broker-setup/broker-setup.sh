echo upload Data Publisher LDES and view definitions
curl -X POST -H "content-type: text/turtle" "http://localhost:9003/ldes/admin/api/v1/eventstreams" -d "@./publisher-server/definitions/occupancy.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:9003/ldes/admin/api/v1/eventstreams/occupancy/views" -d "@./publisher-server/definitions/occupancy.by-page.ttl"

echo upload Data Broker LDES and view definitions
curl -X POST -H "content-type: text/turtle" "http://localhost:9001/ldes/admin/api/v1/eventstreams" -d "@./broker-server/definitions/occupancy.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:9001/ldes/admin/api/v1/eventstreams/occupancy/views" -d "@./broker-server/definitions/occupancy.by-time.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:9001/ldes/admin/api/v1/eventstreams/occupancy/views" -d "@./broker-server/definitions/occupancy.by-location.ttl"
curl -X POST -H "content-type: text/turtle" "http://localhost:9001/ldes/admin/api/v1/eventstreams/occupancy/views" -d "@./broker-server/definitions/occupancy.by-parking.ttl"

echo seed the publisher and broker workbench pipelines
curl -X POST -H "content-type: application/yaml" http://localhost:9004/admin/api/v1/pipeline --data-binary @./publisher-workbench/seed/occupancy-pipeline.yml
curl -X POST -H "content-type: application/yaml" http://localhost:9002/admin/api/v1/pipeline --data-binary @./broker-workbench/seed/client-pipeline.yml

open "http://localhost:9001/ldes/occupancy/by-location"