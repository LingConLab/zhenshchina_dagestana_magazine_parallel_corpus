### "Ženščina Dagestana" (eng. "Woman of Dagestan") parallel corpus

#### **Outline**


"Ženščina Dagestana" is a magazine published in 7 languages spoken in Dagestan republic:
- Avar
- Dargin
- Kumyk
- Lak
- Lezgian
- Russian
- Tabasaran


Versions in different languages have common stories, rubrics, and topics. Aim of this repository is to conveniently collect the available materials and make a parallel corpus out of it. New issues are coming out, they can be gradually added to the materials.


Official page of the magazine, in Russian: https://женщинадагестана.рф


Files in the repository:
1. The `gorjanka_magazine_scrapping.R` script makes folders for 7 languages, parse [html pages with magazine archive](https://xn--80aaaanefedv8cbg8cp7h.xn--p1ai/edition_archive_x), and download PDFs of issues to the corresponding language folder.
2. The `text_extraction_tesseract.ipynb` notebook holds `tesseract`-based OCR script transforming the magazine's PDFs into .txt files. There is also a piece of code collecting OCRed text to a table where texts presented on each page of magazines are presented in a parallel way.
3. The `parallel_texts_table.csv` and `parallel_texts_table.xlsx` are products of the code in the .ipynb file. These are two versions of the same table where all the texts are collected and presented in a parallel way. Content of the table is as follows: 
    - `row_id`: id of the row in the table
    - `issue`: unified id of the issue like "YYYY_N.pdf.txt" where 'YYYY' is the year of publishing and 'N' is the volume
    - `page`: number of the page in the issue
    - `line`: number of the line in the OCRed version of the issue (in the .txt file)
    - `rus`,`avar`,`kumyk`,`lezg`,`tabas`,`darg`,`lak`: line from the issue's version in the corresponding language
    - `all_matching`: boolean variable (True/False values) indicating whether a line is the same in all languages, can be convenient to skip uninteresting chunks of information.