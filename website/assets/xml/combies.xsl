<?xml version="1.0" encoding="UTF-8"?>

<!-- <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected1"></xsl:param>

  <xsl:param name="tokenselected2"></xsl:param>

  <xsl:template match="/">
    <html>
      <body id='replace'>

        <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]">
          <header>

            <h2><xsl:value-of select="name"/></h2>
          </header>
          <div class="centerBlock">
            <p>
              <span class='bold'>Description:
              </span><xsl:value-of select="description"/></p>
            <p>
              <span class='bold'>Datatype:
              </span><xsl:value-of select="datatype"/></p>
            <p>
              <span class='bold'>Ability:
              </span><xsl:value-of select="ability"/></p>
            <p>
              <span class='bold'>Capabilities:
              </span>
              <span><xsl:value-of select="capabilities"/></span>
            </p>
            <p>
              <span class='bold'>Limitations:
              </span>
              <span><xsl:value-of select="limitations"/></span>
            </p>
            <p>
              <span class='bold'>Technical term:
              </span><xsl:value-of select="techterm"/></p>
          </div>
          <div class='example'>
            <xsl:for-each select="examples/ex">
                <h3 class='exampleHeader'><xsl:value-of select="exname"/></h3>
              <div class='exImg'>

                <img>
                  <xsl:attribute name="src">
                    <xsl:value-of select="eximage"/>
                  </xsl:attribute>
                  <xsl:attribute name="width">220px  </xsl:attribute>
                </img>
                <!-- <img src="{<xsl:value-of select="eximage"/>}"> -->
                <!-- <img src="{eximage}" width=200px/> -->
              </div>
              <div class='exText'>

              <p>
                <span class='bold'>Description:
                </span><xsl:value-of select="exdescription"/></p>
              <p>
                <a href="{exlink/@xlink:href}" target="_blank"><xsl:value-of select="exlink"/></a>
              </p>
              <p>
                <a href="{diylink/@xlink:href}" target="_blank"><xsl:value-of select="diylink"/></a>
              </p>
            </div>
            </xsl:for-each>
          </div>

        </xsl:for-each>

      </body>
      <footer>
      </footer>
    </html>
  </xsl:template>

</xsl:stylesheet>
