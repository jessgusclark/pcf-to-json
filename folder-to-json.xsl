<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">
	
    <!-- import your ouvariables.xsl file which will define $ou:root, $ou:site and $ou:dirname -->
	<xsl:import href="../_shared/ouvariables.xsl"/>
	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>
    
	<xsl:template match="/document">
		
        <!-- create a JSON object with the data -->
        <xsl:variable name="json-object">
        {"data" : [
        	<xsl:variable name="folder-path" select="concat($ou:root, $ou:site, $ou:dirname)" />
            <xsl:for-each select="doc( $folder-path )/list/file">
            	<xsl:sort select="node()" />

                <!-- do not chosse files that start with underscore -->
                <xsl:if test="not(starts-with(., '_'))">
                    <xsl:call-template name="open-file">
                        <xsl:with-param name="file-path" select="concat($folder-path, '/', .)" />
                        <xsl:with-param name="last" select="position() = last()" />
                    </xsl:call-template>
                </xsl:if>

            </xsl:for-each>
        ]}</xsl:variable>
        
        <!-- normalize-space() will remove the line breaks and reduce the size -->
        <xsl:copy-of select="normalize-space($json-object)" />
        
        
	</xsl:template>
	
    <xsl:template name="open-file">
    	<xsl:param name="file-path" />
        <xsl:param name="last" />

        <!-- Document call to the file to get its contents -->
        <xsl:variable name="file" select="doc($file-path)/document" />

        {
        "path" : "<xsl:value-of select="replace($file-path, concat($ou:root, $ou:site), '')" />",
        
        <!-- loop throgh each of the parameters -->
        <xsl:for-each select="$file/ouc:properties[@label='config']/parameter">

            <!-- if attribute shortname exists, use that as the name, else use the name without dashes -->
        	<xsl:choose>
        		<xsl:when test="@shortname != ''">
                	"<xsl:value-of select="@shortname" />" :
                </xsl:when>
        		<xsl:otherwise>"<xsl:value-of select="replace(@name, '-', '')" />" :</xsl:otherwise>
        	</xsl:choose>    
            
            <!-- get the users' content of the parameter -->
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
            
            <!-- if there are more parameters, add a comma -->
            <xsl:if test="position() != last()">,</xsl:if>
            
        </xsl:for-each>

        <!-- include the tags for the file -->
        <xsl:variable name="tags-api-call" select="concat('ou:/Tag/GetTags?', 'site=', $ou:site, '&amp;path=', replace(replace($file-path, concat($ou:root, $ou:site), ''), '.html', '.pcf') )" />
        <xsl:variable name="all-tags" select="doc( $tags-api-call )/tags" />
                
        <!-- if tags exist, include them -->
        <xsl:if test="count($all-tags/tag) != 0">
            ,"tags": [
            <xsl:for-each select="$all-tags/tag">
                "<xsl:value-of select="name" />"
                <xsl:if test="position() != last()">,</xsl:if>  
            </xsl:for-each>
            ]
        </xsl:if>

        }
        
        <!-- if this is not the last item in the folder, add a comma -->
        <xsl:if test="not($last)">,</xsl:if>

    </xsl:template>
	
</xsl:stylesheet>
