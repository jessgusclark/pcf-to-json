<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<!--
Implementations Skeletor v3 - 5/10/2014

SECTION PROPERTIES 

Contributors: Your Name Here
Last Updated: Enter Date Here
-->
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">
	
	<xsl:import href="../common.xsl"/>
	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>
    
	<xsl:template match="/document">
		
        <xsl:variable name="json-object">
        {"data" : [
        	<xsl:variable name="folder-path" select="concat($ou:root, $ou:site, $ou:dirname)" />
            <xsl:for-each select="doc( $folder-path )/list/file">
            	<xsl:sort select="node()" />
                <xsl:if test="not(starts-with(., '_'))">
                    <xsl:call-template name="open-file">
                        <xsl:with-param name="file-path" select="concat($folder-path, '/', .)" />
                        <xsl:with-param name="last" select="position() = last()" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        ]}</xsl:variable>
        
        <xsl:copy-of select="normalize-space($json-object)" />
        
        
	</xsl:template>
	
    <xsl:template name="open-file">
    	<xsl:param name="file-path" />
        <xsl:param name="last" />
        <xsl:variable name="file" select="doc($file-path)/document" />
        {
        "path" : "<xsl:value-of select="replace($file-path, concat($ou:root, $ou:site), '')" />",
        <xsl:for-each select="$file/ouc:properties[@label='config']/parameter">
        
        	<xsl:choose>
        		<xsl:when test="@shortname != ''">
                	"<xsl:value-of select="@shortname" />" :
                </xsl:when>
        		<xsl:otherwise>"<xsl:value-of select="replace(@name, '-', '')" />" :</xsl:otherwise>
        	</xsl:choose>    
            
            <xsl:choose>
            	<xsl:when test="@type = 'select'">
                	"<xsl:value-of select="option[@selected = 'true']"/>"
                </xsl:when>
                <xsl:when test="@type = 'checkbox'">
                	<xsl:variable name="checkboxItems">
                        <xsl:for-each select="option[@selected = 'true']">
                            <item><xsl:value-of select="node()" /></item>
                        </xsl:for-each>
                    </xsl:variable>
                    [
                    <xsl:for-each select="$checkboxItems/item">
                    	"<xsl:value-of select="." />"
                        <xsl:if test="position() != last()">,</xsl:if>    
                    </xsl:for-each>
                    ]
                </xsl:when>
                <xsl:otherwise>
                	"<xsl:value-of select="node()" />"
                </xsl:otherwise>
            </xsl:choose>
            
             
            
            <xsl:if test="position() != last()">,</xsl:if>    
            
        </xsl:for-each>
        }
        <xsl:if test="not($last)">,</xsl:if>
    </xsl:template>
	
</xsl:stylesheet>
