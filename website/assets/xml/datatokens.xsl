<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected"></xsl:param>
  <xsl:param name="dataselected" select="data/datatoken[token=$tokenselected]/datatype" ></xsl:param>
  <xsl:template match="/">
    <html>
      <body id='replace'>

        <xsl:for-each select="data/datatoken[token=$tokenselected]">
          <header>

            <h2><xsl:value-of select="datatype"/></h2>

          </header>
          <div class="centerBlock">
            <p>
              <span class='bold'>Description:
              </span><xsl:value-of select="description"/></p>

            <p>
              <span class='bold'>Format:
              </span>
              <span><xsl:value-of select="format"/></span>
            </p>
            <p>
              <span class='bold'>Collection methods:
              </span>
              <span>
                <xsl:value-of select="collection"/></span>
            </p>
          </div>
        </xsl:for-each>
        <div class="centerBlock">
          <p class="bold">Selection of datasets:</p>
          <table border="1">
            <tr bgcolor="#9acd32">
              <th>Dataset</th>
              <th>Description</th>
              <th>Labeled (1=yes)</th>
              <!-- <th>Link</th> -->
            </tr>

            <xsl:for-each select="data/records/record[datatype=$dataselected]">
              <tr>
                <td><a href="{url/@xlink:href}" target="_blank"><xsl:value-of select="dataset"/></a></td>
                <!-- <td><xsl:value-of select="dataset"/></td> -->
                <td><xsl:value-of select="description"/></td>
                <td><xsl:value-of select="labeled"/></td>

              </tr>

            </xsl:for-each>
          </table>
        </div>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
