## Ubuntu Test Run

* Bring up the VM: `vagrant up Ubuntu_16_test`
* Take a snapshot: `vagrant snapshot save Ubuntu_16_test virgin`
* Run the test script of your choice.
* Restore the snapshot: `vagrant snapshot restore Ubuntu_16_test virgin`
* Run your next test.

* Install single JDK on fresh system
	* Java 5
	* Java 6
	* Java 7
	* Java 8
* Multi tenancy JVMs, i.e. 7 running alongside 8
	* Currently installs major versions alongside each other
	* Update versions are automatically upgraded
	* Multi tenanted JVMs can now be specified in a single puppet manifest using multiple defines sections instead of multiple runs to install the JVMs next to each other.
	* Old major versions are still installed, not sure how to fix this without a complete re-organisation.
* Upgrades - in place between update versions with the same major version
	* 8u32 to 8u112 
	* 7u76 to 7u80
	* 6u34 to 6u45
	* 5u22 to 5u20
* Downgrades - between update versions with the same major version, 
rpm with the puppet package manager doesn't like downgrades
	* 8u112 to 8u32
	* 7u80 to 7u76
	* 6u45 to 6u34
	* 5u20 to 5u22
* Upgrades - in place between major versions (multiTenancy => false)
	* 5 to 6
	* 5 to 7
	* 5 to 8
	* 6 to 7
	* 6 to 8
	* 7 to 8
* Downgrades - between major versions (multiTenancy => false)
Alternatives fails to remove the old entries.
	* 8 to 7
	* 7 to 6
	* 8 to 6
	* 6 to 5
	* 7 to 5
	* 8 to 5
* reinstalling
	* a rerun of puppet will reinstall your JDK, this is because the JDK is uninstalled via **rpm** to ensure that the previous update version is removed as the puppet rpm provider installs Java multiple times per major version from Java 8 onwards. 		
* Set defaults via alternatives
	* Java 5
	* Java 6
	* Java 7
	* Java 8
	
* **check for the .1.gz files in the /binman/man1/rmiregistry.1.gz location**
## Minor Upgrades

<table>
    <tr><td>Ubuntu</td>         <td>Minor Upgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</th>    <th>Default Updated?</th>    <th>Alternatives Updated?</th></tr>
    <tr><td>6.34</td>           <td>6.45</td>           <td>true</td>               <td>true</td></tr>  
    <tr><td>7.76</td>           <td>7.80</td>           <td>true</td>               <td>true</td></tr>  
    <tr><td>8.31</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>  
</table>

<table>
    <tr><td>CentOS 6</td>       <td>Minor Upgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</th>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>6.34</td>           <td>6.45</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>7.76</td>           <td>7.80</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.31</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>
</table>

<table>
    <tr><td>CentOS 7</td>       <td>Minor Upgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>6.34</td>           <td>6.45</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>7.76</td>           <td>7.80</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.31</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>
</table>

## Minor Downgrades
<table>
    <tr><td>Ubuntu</td>         <td>Minor Downgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>6.45</td>           <td>6.34</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>7.80</td>           <td>7.76</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.112</td>          <td>8.31</td>           <td>true</td>               <td>true</td></tr>
</table>

<table>
    <tr><td>CentOS 6</td>       <td>Minor Downgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>6.45</td>           <td>6.34</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>7.80</td>           <td>7.76</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.112</td>          <td>8.31</td>           <td>true</td>               <td>false</td></tr>
</table>

<table>
    <tr><td>CentOS 7</td>       <td>Minor Downgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>6.45</td>           <td>6.34</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>7.80</td>           <td>7.76</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.112</td>          <td>8.31</td>           <td>true</td>               <td>false</td></tr>
</table>

## Major Upgrades
<table>
    <tr><td>Ubuntu</td>         <td>Major Upgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>6.45</td>           <td>7.80</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>7.80</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>
    <tr><td>6.45</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>
</table>

<table>
        <tr><td>CentOS 6</td>   <td>Major Upgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>6.45</td>           <td>7.80</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>7.80</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>
    <tr><td>6.45</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>
</table>

<table>
    <tr><td>CentOS 7</td>       <td>Major Upgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>6.45</td>           <td>7.80</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>7.80</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>
    <tr><td>6.45</td>           <td>8.112</td>          <td>true</td>               <td>true</td></tr>
</table>

## Major Downgrades
<table>
    <tr><td>Ubuntu</td>         <td>Major Downgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>7.80</td>           <td>6.45</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.112</td>          <td>7.80</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.112</td>          <td>6.45</td>           <td>true</td>               <td>true</td></tr>
</table>

<table>
    <tr><td>CentOS 6</td>       <td>Major Downgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>7.80</td>           <td>6.45</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.112</td>          <td>7.80</td>           <td>true</td>               <td>false</td></tr>
    <tr><td>8.112</td>          <td>6.45</td>           <td>true</td>               <td>false</td></tr>
</table>

<table>
    <tr><td>CentOS 7</td>       <td>Major Downgrades</td></tr>
    <tr><th>Start Version</th>  <th>End Version</td>    <th>Default Updated?</th>   <th>Alternatives Updated?</th></tr>
    <tr><td>7.80</td>           <td>6.45</td>           <td>true</td>               <td>true</td></tr>
    <tr><td>8.112</td>          <td>7.80</td>           <td>true</td>               <td>false</td></tr>
    <tr><td>8.112</td>          <td>6.45</td>           <td>true</td>               <td>false</td></tr>
</table>

## Observations
Downgrading from a version of Java 8 that isn't update version 112 seems to work without issue.
Downgrading to a previous version from Java 8u112 causes alternatives to be left in an inconsistent state