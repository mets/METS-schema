# METS 2 Samples

## Example METS (version 2)

The [example METS](mets2-example-borndigital.xml) has been created by the METS Editorial Board as a complete METS2 example for born digital material.

## Examples of equivalent METS 1 and METS 2 documents

There are two synthetic examples of METS documents showing changes from METS 1 to METS 2:

* [simple-mets1.xml](simple-mets1.xml) (METS 1); [simple-mets2.xml](simple-mets2.xml) (METS 2): a simple example with two files and minimal metadata.

* [complex-mets1.xml](complex-mets1.xml) (METS 1); [complex-mets2.xml](complex-mets2.xml) (METS 2): a more complex example with multiple file groups, structMaps, and more kinds of metadata.

## Migrations of real METS from version 1 to version 2

Sources:

* HathiTrust METS for [chi.02924743](https://hdl.handle.net/2027/chi.082924743) (see [sample METS](https://www.hathitrust.org/documents/example-hathitrust-google-mets.xml))

* Archivematica [Sample METS](https://github.com/artefactual-labs/am-mets-examples/blob/master/demo-transfer-mets.xml)

* DSpace [SWORD example METS](https://github.com/DSpace/DSpace/blob/main/dspace-sword/example/mets.xml)
  (as dspace-sword-mets.xml)

Changes required were mostly mechanical in all cases:

* change namespace
* wrap `dmdSecs` in `mdGroup`
* change `amdSec` to `mdGroup`
* wrap all `mdGroup`s in `mdSec`
* change `dmdSec` to `md` & add `USE`
* change `techMD`, `sourceMD`, `rightsMD`, `digiprovMD` to `md` & add `USE`
* change `xlink:href` to `LOCREF`
* collapse `LOCTYPE`/`OTHERLOCTYPE` into `LOCTYPE`
* change `ADMID`, `DMDID` to `MDID`
* wrap `structMap` in `structSec`

For the HathiTrust METS, I cleaned up a couple of strangenesses requiring more
internal knowledge of what was happening; specifically, I supplied a direct URL
to the referenced MARC metadata and changed the references to files inside the
ZIP to include the zip file as part of their relative paths.

The zip case is perhaps interesting in that it might seem like a good case for
nested files, but that would lose the ability to group files by use into
separate file groups -- that's an issue in METS1 that is neither helped nor
hindered in METS2, and unrelated to the issue of nested file groups.

It is also perhaps worth noting that the IDs of metadata elements reflected or
included the element name, which is not the same in METS2.

These translations from METS 1 to METS 2 are not intended to be normative or definitive, 
just to give one possibility as to how these documents could be represented using METS 2.
