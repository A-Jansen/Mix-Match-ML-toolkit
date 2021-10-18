<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="tokenselected"></xsl:param>
  <xsl:template match="/">
    <html>
      <body id='replace'>
          <xsl:for-each select="abilities/abilitytoken[token=$tokenselected]">
        <header>

        <h2><xsl:value-of select="ability"/></h2>
      </header>
        <div class="centerBlock">
          <p><span class='bold'>Description: </span><xsl:value-of select="description"/></p>

          <p>
            <span class='bold'>Type: </span>
            <span><xsl:value-of select="type"/></span>
          </p>
          <p>
            <span class='bold'>Technical term:
            </span>
            <span>
              <xsl:value-of select="techterm"/></span>
          </p>
        </div>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
