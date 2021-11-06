<?xml version="1.0" encoding="UTF-8"?>

<!-- <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected1"></xsl:param>

  <xsl:param name="tokenselected2"></xsl:param>

  <xsl:template match="/">
    <html>
      <body id='replace'>

        <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]">

          <xsl:choose>

            <xsl:when test="@exist = 'no'">
              <header>
                <h2>Sorry!</h2>
                <p class='centerText' style="text-transform:none; ">This is not a common combination and no examples currently exist on this website</p>
              </header>
              <div class="centerBlock">
                <p>
                  <span class='bold'>Datatype:
                  </span><xsl:value-of select="datatype"/> data</p>
                <p>
                  <span class='bold'>Ability:
                  </span><xsl:value-of select="ability"/></p>

              </div>
            </xsl:when>

            <xsl:otherwise>
              <header>
                <h2><xsl:value-of select="name"/></h2>
              </header>
              <div class="centerBlock">
                <p>
                  <span class='bold'>Description:
                  </span><xsl:value-of select="description"/></p>
                <p>
                  <span class='bold'>Datatype:
                  </span><xsl:value-of select="datatype"/> data</p>
                <p>
                  <span class='bold'>Ability:
                  </span><xsl:value-of select="ability"/></p>
                <!-- <p>
                  <span class='bold'>Capabilities:
                  </span>
                  <ul>

                    <xsl:for-each select="capabilities/*">
                      <li><xsl:value-of select="@value"/></li>
                    </xsl:for-each>
                  </ul>
                </p>
                <p>
                  <span class='bold'>Limitations:
                  </span>

                  <ul>

                    <xsl:for-each select="limitations/*">
                      <li><xsl:value-of select="@value"/></li>
                    </xsl:for-each>
                    <li>ML is not perfect and will always make some errors</li>
                    <li>ML is non-deterministic: the output can be different each time</li>
                  </ul>
                </p> -->
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

                      <xsl:attribute name="width">220px
                      </xsl:attribute>
                    </img>
                    <!-- <img src="{<xsl:value-of select="eximage"/>}"> -->
                    <!-- <img src="{eximage}" width=200px/> -->
                  </div>
                  <div class='exText'>

                    <p>
                      <span class='bold'>Description:
                      </span><xsl:value-of select="exdescription"/></p>
                    <p>
                      <a href="{exlink/@xlink:href}" target="_blank">See example</a>
                    </p>
                    <p>
                      <a href="{diylink/@xlink:href}" target="_blank">Train it yourself</a>
                    </p>
                  </div>
                </xsl:for-each>
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>

      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>
