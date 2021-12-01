<?xml version="1.0" encoding="UTF-8"?>

<!-- <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected1"></xsl:param>

  <xsl:param name="tokenselected2"></xsl:param>

  <xsl:param name="label"></xsl:param>

  <xsl:param name="learning"></xsl:param>

  <xsl:template match="/">
    <html>
      <body id='replace'>

        <!-- <xsl:for-each select=""> -->

        <xsl:choose>

          <xsl:when test="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]/@exist = 'no'">
            <header>
              <div class="headerData">

                <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]">
                  <div class='leftheader'>
                    <div class='leftdiv'>

                      <img>

                        <xsl:attribute name="class">datacombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value=$label]"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='datatoken token'><xsl:value-of select="datatype"/></h3>
                    </div>
                    <div class='rightdiv'>

                      <img>

                        <xsl:attribute name="class">abilitycombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value=$learning]"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='abilitytoken token'><xsl:value-of select="ability"/></h3>

                    </div>
                  </div>
                  <div class="rightheader">
                    <h3 class='type combi'>Sorry!</h3>
                    <p class='description'>This is not a common combination and no examples currently exist on this website</p>
                  </div>
                </xsl:for-each>
              </div>
            </header>
          </xsl:when>

          <xsl:otherwise>
            <header>
              <div class="headerData">

                <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]">
                  <div class='leftheader'>
                    <div class='leftdiv'>

                      <img>

                        <xsl:attribute name="class">datacombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value=$label]"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='datatoken token'><xsl:value-of select="datatype"/></h3>
                      <!-- <p> <xsl:value-of select = "$label" /></p> <p> <xsl:value-of select = "../images/im[@value=$label]" /></p> -->
                    </div>
                    <div class='rightdiv'>

                      <img>

                        <xsl:attribute name="class">abilitycombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value=$learning]"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='abilitytoken token'><xsl:value-of select="ability"/></h3>
                      <!-- <p> <xsl:value-of select = "$learning" /></p> <p> <xsl:value-of select = "../images/im[@value=$learning]" /></p> -->
                    </div>

                    <!-- <p class='overlaptextBig' style="top: 50px; transform: translate(-30%);"><xsl:value-of select="abilities/abilitytoken[token=$tokenselected]/ability"/></p> <p class='overlaptextability' style="top: 130px; transform:
                    translate(-30%);">Reinforcement learning</p> -->

                  </div>

                  <div class='rightheader'>
                    <h3 class='type combi'><xsl:value-of select="name"/></h3>
                    <p class='description'>
                      <xsl:value-of select="description"/></p>
                    <p>
                      <span class='bold combi'>Technical terms:
                      </span>
                      <span><xsl:value-of select="techterm"/></span>
                    </p>

                  </div>
                </xsl:for-each>
              </div>
            </header>

            <div class='example'>

              <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]/examples/ex">

                <div class='exImg'>
                  <img>

                    <xsl:attribute name="src">
                      <xsl:value-of select="eximage"/>
                    </xsl:attribute>

                    <xsl:attribute name="class">exampleImage
                    </xsl:attribute>
                  </img>
                </div>
                <div class='exText'>
                  <h3 class='exampleHeader'><xsl:value-of select="exname"/></h3>
                  <p>
                    <span class='bold'>Description:
                    </span><xsl:value-of select="exdescription"/></p>
                  <p>
                    <a href="{exlink/@xlink:href}" target="_blank">
                      <xsl:attribute name="onclick">sendlinkOOCSI("examplelink","<xsl:value-of select="exlink/@xlink:href"/>")
                      </xsl:attribute>
                      See example</a>
                  </p>
                  <p>
                    <a href="{diylink/@xlink:href}" target="_blank">
                      <xsl:attribute name="onclick">sendlinkOOCSI("diylink","<xsl:value-of select="diylink/@xlink:href"/>")
                      </xsl:attribute>
                      Train it yourself</a>
                  </p>
                </div>
              </xsl:for-each>
            </div>
          </xsl:otherwise>
        </xsl:choose>

      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>
