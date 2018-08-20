<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">
		
	<xsl:template match="/document">
		<html lang="en">
			
			<head>
				<link href="//netdna.bootstrapcdn.com/bootswatch/3.1.0/cerulean/bootstrap.min.css" rel="stylesheet"/>
				<link href="/_resources/css/oustaging.css" rel="stylesheet" />
				<style>
					body{
					font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
					}
					.ox-regioneditbutton {
					display: none;
					}
					
					tr {border-bottom:1px solid #EBEBEB}
					tr td {padding:4px 0;}
					
					tr td.indent {padding-left:15px}
				</style>
			</head>
			
			<body id="properties">
				
				<div class="container">
					<h1><xsl:value-of select="page/@type" /> datafile</h1>
					<div class="alert alert-warning">
						<p><strong>Data File:</strong> This file does not need to be published, however the pages that pull data from this file do.</p>
					</div>
                    
					<table width="100%">
						<thead>
							<th width="25%">Property Name</th>
							<th width="75%">Value</th>
						</thead>
						<xsl:for-each select="ouc:properties[@label='config']/parameter">
							<tr>
								<td><xsl:value-of select="@prompt"/></td>
								<xsl:choose>
									<xsl:when test="@type = 'select'">
										<td><xsl:value-of select="option[@selected = 'true']"/></td>
									</xsl:when>
                                    <xsl:when test="@type = 'checkbox'">
                                    	<td>
                                        	<xsl:for-each select="option[@selected = 'true']">
                                            	<xsl:value-of select="node()" /><br/>
                                            </xsl:for-each>
                                        </td>
                                    </xsl:when>
									<xsl:otherwise>
										<td><xsl:value-of select="."/></td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:for-each>
					</table>
					
             		<h2 class="small">Tags</h2>       
                    <xsl:variable name="api-call" select="concat('ou:/Tag/GetTags?', 'site=', $ou:site, '&amp;path=', replace($ou:path, '.html', '.pcf') )" />
                    <xsl:variable name="all-tags" select="doc( $api-call )/tags" />
                    
                  <xsl:choose>
                  
                      <xsl:when test="count($all-tags/tag) != 0">
                            <ul class="inline-list">
                            <xsl:for-each select="$all-tags/tag">
                            	<xsl:sort select="name" />
                                <li class="badge primary">
                                    <xsl:value-of select="replace(name, 'conferences-', '')" />
                                </li>
                            </xsl:for-each>
                            </ul>
                        </xsl:when>
                        <xsl:otherwise>
                            <em>No tags associated with this datafile.</em>
                        </xsl:otherwise>
                    </xsl:choose>
                    
				</div>
				
				<div style="display:none;">
					<ouc:div label="fake" group="fake" button="hide"/>
				</div>
				
			</body>
		</html>
		
			
	</xsl:template>
	
	
</xsl:stylesheet>
