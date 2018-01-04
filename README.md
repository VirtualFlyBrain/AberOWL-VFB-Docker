To run:
```docker run -d --name aberowl-vfb -p 31337:31337 virtualflybrain/aberowl-vfb```

Note: to keep the container small loading latest ontology is done at runtime and takes a few minutes before the server is started hence no response will be given on port 31337 until the server is ready to go.

readiness test:
http://localhost:31337/api/getStatuses.groovy

For full spects of the aber-owl.net api see: http://aber-owl.net/help 

 
