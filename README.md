# pcf-to-json

Data Files for OU Campus and converting them into a collective JSON file.

## data-file.xsl

This is the basic template for data-files. It loops through the parameters in `ouc:properties label="config"` and returns their value. This file was based of [OmniUpdate's](https://github.com/omniupdate) _props file and expanded to include tags and updated formatting.

## folder-to-json.xsl

This file will take all the files that are located in a directory and creates a JSON file with the information from their parameters. You will need to import the `ouvariables.xsl` file to have access to $ou:root, $ou:site, and $ou:dirname.

To reduce the size of the JSON file, you can use the attribute `shortname` which will be the name of the property:

```
<parameter name="name" shortname="fn" type="text" prompt="First Name">Jesse</parameter>
```

will result in:

```
"fn":"Jesse"
```

## _folder-to-json.pcf

A `.pcf` file that is is parsed by the XSL. This file starts with an underscore so the XSL will ignore it when looping through files in the directory.

## sample-data-file.pcf

A sample data file. Ideally, you would have multiple of these files in a single folder with one file using the `_folder-to-json.pcf` template.