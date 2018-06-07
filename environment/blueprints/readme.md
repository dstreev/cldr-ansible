I've include a few samples here for reference.

\*\_Blueprint.json is an artifact from an existing cluster, retrieved from Ambari with:

[Cluster Blueprint Extraction](http://ambari:8080/api/v1/clusters/MYCLUSTERNAME?format=blueprint)

\*\_Cluster.json is an artifact from an existing cluster that contains information about all the hosts and components in a cluster.  I use this, along with the above blueprint from the cluster to create a cluster 'Template' file that can be used to rebuild a cluster.

[Cluster Template File](build/DK01_template.json)

This file is created from a utility I wrote here:
