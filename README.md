Spatial Accessibility Analysis – Hosur, Tamil Nadu
Project Overview

This project analyses spatial accessibility to essential services in Hosur, Tamil Nadu, with a focus on healthcare and education availability around residential locations.

Using PostgreSQL/PostGIS for spatial analysis and QGIS for visualisation, the project identifies:

Underserved residential areas

Distance-based healthcare accessibility

Spatial imbalance between educational and healthcare services

The goal is to demonstrate how spatial databases and GIS reveal patterns that are not visible in non-spatial data.

Study Area

Location: Hosur, Tamil Nadu, India

Extent: Administrative boundary of Hosur

Analysis is restricted strictly to this region.

Data Sources

All spatial data was obtained from OpenStreetMap (OSM).

Datasets Used

Residential homes

Hospitals

Clinics

Schools

Note: Some residential features did not contain name attributes. Synthetic identifiers were generated to improve clarity during analysis.

Tools & Technologies

PostgreSQL

PostGIS (spatial extension)

QGIS (visualisation and spatial processing)

Coordinate Reference System

EPSG:3857 (WGS 84 / Pseudo-Mercator)
Used to ensure distance calculations are performed in meters.

Methodology

Spatial analysis was performed using PostGIS spatial SQL functions, including:

ST_DWithin – distance-based filtering

ST_Distance – nearest-neighbour analysis

Spatial buffers – to represent service catchment areas

Results from SQL queries were visualised directly in QGIS.

Analyses Performed
1. Underserved Homes

Question:
Which homes do not have access to a hospital within 5 km?

Method:

A 5 km buffer was created around all hospitals

Homes outside the buffer were classified as underserved

Outcome:
Peripheral residential areas were identified as having limited healthcare access.

2. Nearest Healthcare Distance

Question:
How far does each home need to travel to reach the nearest healthcare facility?

Method:

Nearest-neighbour analysis using ST_Distance

Includes both hospitals and clinics

Outcome:
Some homes were found to be more than 5–6 km away from healthcare facilities, indicating higher access risk.

3. Service Imbalance (Education vs Healthcare)

Question:
Do homes with good access to schools also have good access to hospitals?

Method:

Counted schools and hospitals within a 3 km radius of each home

Calculated an imbalance score (schools − hospitals)

Outcome:
Educational and healthcare services are not evenly distributed, revealing spatial inequality.

Visualisation

All results were visualised in QGIS using:

Buffer maps

Graduated symbology

Diverging colour schemes

Maps were used to clearly communicate spatial patterns and service gaps.

Key Findings

Central Hosur generally has better access to services

Peripheral areas are consistently underserved, especially for healthcare

Distance-based analysis reveals the severity of accessibility issues

Access to education does not guarantee access to healthcare

Conclusion

This project demonstrates how spatial databases combined with GIS visualisation can provide meaningful insights into real-world accessibility problems.
Spatial analysis highlights service gaps that would not be apparent using traditional, non-spatial approaches.
