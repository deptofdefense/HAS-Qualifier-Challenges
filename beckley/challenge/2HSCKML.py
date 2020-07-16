        if camlookrng < 250000:
              kml = (
                '<?xml version="1.0" encoding="UTF-8"?>\n'
                '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
                '<Placemark>\n'
                '<name>The satellite couldn\'t have been this close, try zooming out.</name>\n'
                '<Point>\n'
                '<coordinates>%.6f,%.6f</coordinates>\n'
                '</Point>\n'
                '</Placemark>\n'
                '</kml>'
              ) %(camlooklng, camlooklat)
        else:
            kml = (
                '<?xml version="1.0" encoding="UTF-8"?>\n'
                '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
                '<Placemark>\n'
                '<name>CLICK FOR FLAG</name>\n'
                '<description>'+flag+'</description>\n'
                '<Point>\n'
                '<coordinates>-77.0354,38.889100</coordinates>\n'
                '</Point>\n'
                '</Placemark>\n'
                '</kml>'
            ) 
else:
      kml = (
             '<?xml version="1.0" encoding="UTF-8"?>\n'
             '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
             '<Placemark>\n'
             '<name>Keep Looking...</name>\n'
             '<Point>\n'
             '<coordinates>%.6f,%.6f</coordinates>\n'
             '</Point>\n'
             '</Placemark>\n'
             '</kml>'
            ) %(camlooklng, camlooklat)
       
print 'Content-Type: application/vnd.google-earth.kml+xml\n'
print kml
