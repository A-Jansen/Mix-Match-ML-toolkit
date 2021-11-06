<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected"></xsl:param>

  <xsl:param name="dataselected" select="data/datatoken[ltoken=$tokenselected]/datatype"></xsl:param>

  <xsl:template match="/">
    <html>
      <body id='replace'>
        <!-- <img src="assets/photos/label.png" width="80"> -->

        <header>
          <!-- <xsl:for-each select="data/datatoken[ltoken=$tokenselected]"> -->
          <div class="headerData">
            <div class='labels'>
              <img>
                <xsl:attribute name="class">labelimage
                </xsl:attribute>

                <xsl:attribute name="src"><xsl:value-of select="data/labelimage"/>
                </xsl:attribute>
              </img>
            </div>
            <div class='centerHeader'>
              <h2>
                <xsl:value-of select="data/datatoken[ltoken=$tokenselected]/datatype"/> data
              </h2>
              <p class='centerText'><xsl:value-of select="data/datatoken[ltoken=$tokenselected]/structure"/>
                dataset
              </p>
            </div>
          </div>

          <!-- <img src="assets/photos/label.png" width="80"> -->
        </header>

        <xsl:for-each select="data/datatoken[ltoken=$tokenselected]">
          <div class="centerBlock">
            <p>
              <span class='bold'>Description:
              </span><xsl:value-of select="description"/></p>

            <p>
              <span class='bold'>Possible formats:
              </span>
              <span><xsl:value-of select="format"/></span>
            </p>
            <!-- <p> <span class='bold'>Collection methods: </span> <span> <xsl:value-of select="collection"/></span> </p> -->

            <p class="bold">Selection of datasets:</p>
          </div>
        </xsl:for-each>
        <div>

          <table>
            <tr >
              <th>Dataset</th>
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
