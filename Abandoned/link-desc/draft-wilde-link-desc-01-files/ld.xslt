<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ld="urn:ietf:rfc:XXXX" exclude-result-prefixes="ld">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Link Descriptions</title>
                <style type="text/css">
                    ul { margin : 0 }
                    .msg { color : #C0C0C0 }
                </style>
            </head>
            <body>
                <h1>Link Descriptions</h1>
                <xsl:for-each select="//*[ ld:var | ld:hint ]">
                    <hr/>
                    <xsl:for-each select=" @href | @hreft | @ld:href | @ld:hreft ">
                        <h2>
                            <code>
                                <xsl:value-of select="name()"/>
                                <xsl:text>="</xsl:text>
                                <a href="{.}">
                                    <xsl:value-of select="."/>
                                </a>
                                <xsl:text>"</xsl:text>
                            </code>
                        </h2>
                    </xsl:for-each>
                    <xsl:if test="@rel">
                        <h3>
                            <code>
                                <xsl:text>rel="</xsl:text>
                                <xsl:value-of select="@rel"/>
                                <xsl:text>"</xsl:text>
                            </code>
                        </h3>
                    </xsl:if>
                    <table rules="none" style="margin : 15px">
                        <tr>
                            <th align="right">Documentation:</th>
                            <td>
                                <xsl:call-template name="documentation"/>
                            </td>
                        </tr>
                    </table>
                    <xsl:if test="ld:var">
                        <h4>Variables:</h4>
                        <table rules="all" border="1" cellpadding="5">
                            <thead>
                                <tr>
                                    <th>Variable</th>
                                    <th>Concept</th>
                                    <th>Default</th>
                                    <th>Value Range</th>
                                    <th>Documentation</th>
                                </tr>
                            </thead>
                            <xsl:for-each select="ld:var">
                                <xsl:sort select="@name"/>
                                <tr>
                                    <td>
                                        <xsl:value-of select="@name"/>
                                    </td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="@concept">
                                                <q>
                                                    <xsl:value-of select="@concept"/>
                                                </q>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="msg">n/a</span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="@default">
                                                <q>
                                                    <code>
                                                        <xsl:value-of select="@default"/>
                                                    </code>
                                                </q>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="msg">n/a</span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="ld:restriction">
                                                <div>
                                                    <xsl:text>Base: </xsl:text>
                                                    <code>
                                                        <xsl:choose>
                                                            <xsl:when test="contains(ld:restriction/@base, ':')">
                                                                <xsl:value-of select="ld:restriction/@base"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <a href="http://www.w3.org/TR/xmlschema-2/#{ld:restriction/@base}">
                                                                    <xsl:value-of select="concat('xs:', ld:restriction/@base)"/>
                                                                </a>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </code>
                                                </div>
                                                <xsl:if test="ld:restriction/ld:*">
                                                    <ul>
                                                        <xsl:for-each select="ld:restriction/ld:*">
                                                            <xsl:sort select="local-name()"/>
                                                            <li>
                                                                <code>
                                                                    <a href="http://www.w3.org/TR/xmlschema-2/#rf-{local-name()}">
                                                                        <xsl:value-of select="concat('xs:',local-name())"/>
                                                                    </a>
                                                                    <xsl:text>="</xsl:text>
                                                                    <xsl:value-of select="@value"/>
                                                                    <xsl:text>"</xsl:text>
                                                                </code>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="msg">n/a</span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td>
                                        <xsl:call-template name="documentation"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:if>
                    <xsl:if test="ld:hint">
                        <h4>Hints:</h4>
                        <table rules="all" border="1" cellpadding="5">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Value</th>
                                    <th>Documentation</th>
                                </tr>
                            </thead>
                            <xsl:for-each select="ld:hint">
                                <xsl:sort select="@name"/>
                                <tr>
                                    <td>
                                        <xsl:value-of select="@name"/>
                                    </td>
                                    <td>
                                        <code>
                                            <xsl:value-of select="@value"/>
                                        </code>
                                    </td>
                                    <td>
                                        <xsl:call-template name="documentation"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:if>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="documentation">
        <xsl:choose>
            <xsl:when test="ld:documentation">
                <ul>
                    <xsl:for-each select="ld:documentation">
                        <li>
                            <xsl:value-of select="node()"/>
                            <xsl:if test="@xml:lang">
                                <xsl:text> </xsl:text>
                                <span class="msg">
                                    <xsl:text>(</xsl:text>
                                        <code>
                                            <xsl:text>xml:lang="</xsl:text>
                                            <xsl:value-of select="@xml:lang"/>
                                            <xsl:text>"</xsl:text>
                                        </code>
                                    <xsl:text>)</xsl:text>
                                </span>
                            </xsl:if>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <span class="msg">n/a</span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>