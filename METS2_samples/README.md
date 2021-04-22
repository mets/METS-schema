Sample migrations of METS from version 1 to version 2

Sources:

- HathiTrust METS for chi.02924743 (see https://babel.hathitrust.org/cgi/htdc,
  log in via Google if necessary)

- Archivematica Sample METS:
  https://github.com/artefactual-labs/am-mets-examples/blob/master/demo-transfer-mets.xml

- DSpace SWORD example METS:
  https://github.com/DSpace/DSpace/blob/main/dspace-sword/example/mets.xml
  (as dspace-sword-mets.xml)


Changes required were mostly mechanical in both cases:

- change namespace
- wrap dmdSecs in mdGroup
- change amdSec to mdGroup
- wrap all mdGroups in mdSec
- change dmdSec to md & add USE
- change techMD, sourceMD, rightsMD, digiprovMD to md & add USE
- change xlink:href to href
- remove FLocat LOCTYPE/OTHERLOCTYPE; for case of OTHERLOCTYPE="SYSTEM" leave href as-is and assume hrefs relative to some implied base
- change ADMID, DMDID to MDID
- wrap structMap in structSec

For the HathiTrust METS, I cleaned up a couple of strangenesses requiring more
internal knowledge of what was happening; specifically, I supplied a direct URL
to the referenced MARC metadata and changed the references to files inside the
ZIP to include the zip file as part of their relative URLs.

The zip case is perhaps interesting in that it might seem like a good case for
nested files, but that would lose the ability to group files by use into
separate file groups -- that's an issue in METS1 that is neither helped nor
hindered in METS2, and unrelated to the issue of nested file groups.

Also perhaps worth noting that the IDs of metadata elements reflected or
included the element name, which is not the same in METS2.
