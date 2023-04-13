<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2008/05/skos#"
    xmlns:vs="http://www.w3.org/2003/06/sw-vocab-status/ns#" exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Written by Timothy Ryan Mendenhall (Columbia University Libraries) on 13 April 2023 to extract data from the SKOS RDF schema for use in a demonstration on loading properties to Wikibase instances -->
    <!-- Takes the key data elements from the SKOS schema and outputs a .tsv file -->
    
    <!-- Formatting elements -->
    <xsl:output encoding="UTF-8" method="text"/>
    <xsl:strip-space elements="*"/>
    
    <!-- General formatting template -->
    <xsl:template match="/">
        <xsl:text>Object Type&#x9;Label&#x9;Definition&#x9;URI&#x9;Alias&#x9;Disjoint&#x9;SubclassOf&#x9;Range&#x9;Domain&#x9;Inverse&#x9;SubpropertyOf&#x9;Property type&#xA;</xsl:text>
        <xsl:for-each select="rdf:RDF/owl:Class">
            <xsl:text>Class&#x9;</xsl:text>
            <xsl:call-template name="general"/>
        </xsl:for-each>
        <xsl:for-each select="rdf:RDF/owl:DatatypeProperty">
            <xsl:text>Datatype property&#x9;</xsl:text>
            <xsl:call-template name="general"/>
        </xsl:for-each>
        <xsl:for-each select="rdf:RDF/owl:ObjectProperty">
            <xsl:text>Object property&#x9;</xsl:text>
            <xsl:call-template name="general"/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- General template for extracting data from elements -->
    
    <xsl:template name="general">
        <xsl:value-of select="rdfs:label"/>
        <xsl:text>&#x9;</xsl:text>
        <xsl:value-of select="skos:definition"/>
        <xsl:for-each select="rdfs:comment">
            <xsl:call-template name="comment"/>
        </xsl:for-each>
        <xsl:text>&#x9;</xsl:text>
        <xsl:value-of select="./@rdf:about"/>
        <xsl:text>&#x9;</xsl:text>
        <xsl:analyze-string select="./@rdf:about" regex=".+(skos).(.+)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
        <xsl:text>&#x9;</xsl:text>
        <xsl:for-each select="owl:disjointWith">
            <xsl:call-template name="disjoint"/>
        </xsl:for-each>
        <xsl:text>&#x9;</xsl:text>
        <xsl:for-each select="rdfs:subClassOf">
            <xsl:call-template name="disjoint"/>
        </xsl:for-each>
        <xsl:text>&#x9;</xsl:text>
        <xsl:for-each select="rdfs:range">
            <xsl:call-template name="disjoint"/>
        </xsl:for-each>
        <xsl:text>&#x9;</xsl:text>
        <xsl:for-each select="rdfs:domain">
            <xsl:call-template name="disjoint"/>
        </xsl:for-each>
        <xsl:text>&#x9;</xsl:text>
        <xsl:for-each select="owl:inverseOf">
            <xsl:call-template name="disjoint"/>
        </xsl:for-each>
        <xsl:text>&#x9;</xsl:text>
        <xsl:for-each select="rdfs:subPropertyOf">
            <xsl:call-template name="disjoint"/>
        </xsl:for-each>
        <xsl:text>&#x9;</xsl:text>
        <xsl:for-each select="rdf:type">
            <xsl:call-template name="disjoint"/>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <!-- Template for appending comments to definition -->
    
    <xsl:template name="comment">
        <xsl:text> </xsl:text>
        <xsl:value-of select="."/>
    </xsl:template>
    
    <!-- Template for all other subelements.  Adds a pipe delimiter if there are multiple instances of an element -->
    
    <xsl:template name="disjoint">
        <xsl:if test="position()>1">
            <xsl:text>|</xsl:text>
        </xsl:if>
        <xsl:analyze-string select="./@rdf:resource" regex=".+#(.+)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>
