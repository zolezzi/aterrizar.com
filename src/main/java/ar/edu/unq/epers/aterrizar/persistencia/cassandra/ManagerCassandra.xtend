package ar.edu.unq.epers.aterrizar.persistencia.cassandra


import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Host
import com.datastax.driver.core.Session
import org.eclipse.xtend.lib.annotations.Accessors


@Accessors
class ManagerCassandra {
	Cluster cluster
	Session session	
	
	new(){
		createSession()
		
	}

	def connect(String node) {
		cluster = Cluster.builder().addContactPoint(node).build()
		val metadata = cluster.getMetadata();
		System.out.printf("Connected to cluster: %s\n", metadata.getClusterName());
		for (Host host : metadata.getAllHosts()) {
			System.out.printf("Datatacenter: %s; Host: %s; Rack: %s\n", host.getDatacenter(), host.getAddress(),
				host.getRack());
		}
	}

	def close() {
		cluster.close()
	}
	

	def getSession() {
		if (session == null) {
			session = createSession()
		}
		return session
	}

	def static Session createSession() {

		val cluster = Cluster.builder().addContactPoint("localhost").build()
		return cluster.connect()
	}	
}