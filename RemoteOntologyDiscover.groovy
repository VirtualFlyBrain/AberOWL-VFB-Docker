/**
 * The RemoteOntologyDiscover trolls through various sources to find new ontologies
 */
@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7' )
@Grab(group='redis.clients', module='jedis', version='2.6.2')

import groovyx.net.http.HTTPBuilder
import java.text.SimpleDateFormat
import db.*
import java.util.Date

String BIO_API_ROOT = 'http://data.bioontology.org/'
String BIO_API_KEY = '24e0413e-54e0-11e0-9d7b-005056aa3316'
String ABEROWL_API = 'http://aber-owl.net/service/api/'

def oBase = new OntologyDatabase()
def newO = []
println "Creating VFB"
exOnt = oBase.createOntology([
  'id': 'VFB',
  'name': 'VirtualFlyBrain',
  'source': 'VirtualFlybrain.org'
  ])
def lastSubDate = new Date().toTimestamp().getTime() / 1000 // /
try {
  exOnt.addNewSubmission([
      'released': lastSubDate,
      'download': 'http://www.virtualflybrain.org/owl/vfb.owl'
    ])

  exOnt.description = submissions[0].description

  exOnt.homepage = submissions[0].homepage
  exOnt.contact = []
  exOnt.contact << 'support@virtualflybrain.org'
  newO.add(exOnt.id)
  oBase.saveOntology(exOnt)
  new HTTPBuilder().get( uri: ABEROWL_API + 'reloadOntology.groovy', query: [ 'name': exOnt.id ] ) { r, s ->
    println "Updated " + exOnt.id
    println s
  }
} catch(groovyx.net.http.HttpResponseException e) {
  println "Ontology disappeared"
  println e.getMessage()
} catch(java.net.SocketException e) {
  println "idk"
}
