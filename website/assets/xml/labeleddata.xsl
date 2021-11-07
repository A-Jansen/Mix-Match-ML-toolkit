<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected"></xsl:param>

  <xsl:param name="dataselected" select="data/datatoken[ltoken=$tokenselected]/dataname"></xsl:param>

  <xsl:template match="/">
    <html>
      <body id='replace'>
        <header>

          <div class="headerData">
            <div class='leftheader'>
              <img>

                <xsl:attribute name="class">labelimage
                </xsl:attribute>

                <xsl:attribute name="src"><xsl:value-of select="data/labeledimage"/>
                </xsl:attribute>
              </img>
              <img>

                <xsl:attribute name="class">dataimage
                </xsl:attribute>

                <xsl:attribute name="src"><xsl:value-of select="data/datatoken[ltoken=$tokenselected]/image"/>
                </xsl:attribute>
              </img>
              <p class='overlaptext'><xsl:value-of select="data/datatoken[ltoken=$tokenselected]/datatype"/></p>
              <p class='overlaptext2'>Labeled training dataset</p>
            </div>

            <div class='rightheader'>
              <xsl:for-each select="data/datatoken[ltoken=$tokenselected]">
                <h3 class='type labeled' ><xsl:value-of select="dataname"/> data</h3>
                <h4 class=''><xsl:value-of select="structure"/> data</h4>
                <p class='description'>
                <xsl:value-of select="description"/></p>
                <p>
                  <span class='bold labeled'>Possible formats:
                  </span>
                  <span><xsl:value-of select="format"/></span>
                </p>

              </xsl:for-each>
            </div>

          </div>

        </header>

        <div class='centerBlock'>
          <p class="bold labeled">Selection of datasets:</p>
          <table>
            <tr style="background-color: #0F75B8;">
              <th >Dataset</th>
              <th>Description</th>
              <th>Labeled</th>
              <!-- <th>Link</th> -->
            </tr>

            <xsl:for-each select="data/records/record[datatype=$dataselected  and labeled=1]">
              <tr>
                <td>
                  <a href="{url/@xlink:href}" target="_blank"><xsl:value-of select="dataset"/></a>
                </td>
                <!-- <td><xsl:value-of select="dataset"/></td> -->
                <td><xsl:value-of select="description"/></td>
                <td><xsl:value-of select="labeled"/></td>

              </tr>

            </xsl:for-each>
          </table>
        </div>

      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>
