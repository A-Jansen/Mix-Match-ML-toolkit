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
              <h2>Sorry!</h2>
              <p class='centerText' style="text-transform:none; ">This is not a common combination and no examples currently exist on this website</p>
            </header>
            <!-- <div class="centerBlock"> <p> <span class='bold'>Datatype: </span><xsl:value-of select="datatype"/> data</p> <p> <span class='bold'>Ability: </span><xsl:value-of select="ability"/></p> </div> -->
          </xsl:when>

          <xsl:otherwise>
            <header>

              <div class="headerData">
                <div class='leftheader'>
                  <!-- <img> <xsl:attribute name="class">reinforcementimage </xsl:attribute> <xsl:attribute name="src"><xsl:value-of select="abilities/reinforcement"/> </xsl:attribute> </img> -->
                  <!-- <p class='overlaptextBig' style="top: 50px; transform: translate(-30%);"><xsl:value-of select="abilities/abilitytoken[token=$tokenselected]/ability"/></p> <p class='overlaptextability' style="top: 130px; transform:
                  translate(-30%);">Reinforcement learning</p> -->

                </div>

                <div class='rightheader'>

                  <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]">
                    <h3 class='type combi'><xsl:value-of select="name"/></h3>
                    <p class='description'>
                      <xsl:value-of select="description"/></p>
                    <p>
                      <span class='bold combi'>Technical terms:
                      </span>
                      <span><xsl:value-of select="techterm"/></span>
                    </p>
                  </xsl:for-each>
                </div>
              </div>
            </header>

            <div class='example'>

              <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]/examples/ex">
                <h3 class='exampleHeader'><xsl:value-of select="exname"/></h3>
                <div class='exImg'>
                  <img>

                    <xsl:attribute name="src">
                      <xsl:value-of select="eximage"/>
                    </xsl:attribute>

                    <xsl:attribute name="width">220px
                    </xsl:attribute>
                  </img>
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

      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>
