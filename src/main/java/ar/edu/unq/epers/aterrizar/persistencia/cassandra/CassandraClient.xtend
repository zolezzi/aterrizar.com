package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Metadata
import com.datastax.driver.core.Host

class CassandraClient {

	Cluster cluster
	
	def connect(String node) {
		cluster = Cluster.builder().addContactPoint(node).build()
		var Metadata metadata = cluster.getMetadata()
			System.out.printf("Connected to cluster: %s\n", metadata.getClusterName())
		for (Host host : metadata.getAllHosts()) {
			System.out.printf("Datacenter: %s; Host: %s; Rack: %s\n",
			host.getDatacenter(), host.getAddress(), host.getRack());
		}
	}
	
	def close() {
		cluster.shutdown();
	}

	public static def main(String[] args) {
		var client = new CassandraClient();
		client.connect("127.0.0.1");
		client.close();
	}
}