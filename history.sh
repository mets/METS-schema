set -eux


# commiters
jerry="Jerome McDonough <jmcdonou@illinois.edu>"
brian="Brian Tingle <brian.tingle.cdlib.org@gmail.com>"
rick="Rick Beaubien <rick.berkeley.edu@example.edu>"
tom="Thomas Habing <thabing@illinois.edu>"

git init


cp mets.beta.06-07-01.xsd mets.xsd
git add mets.xsd
git commit --author="$jerry" --date="2001-06-07 12:00" -m "26 changes from alpha to beta noted in comments"
git tag beta
rm mets.xsd

cp mets.gamma.10-24-01.xsd mets.xsd
wget http://www.loc.gov/standards/mets/version11/xlink.xsd # is this the correct xlink.xsd?
git add xlink.xsd
git commit --author="$jerry" --date="2001-10-24 12:00" -m "1. Added optional fileSec element beneath METS root element to contain fileGrps.  2. Created subsidiary schema file xlink.xsd for XLink attributes, restored XLink attributes to mptr element, and added XLink support to mdRef and FLocat.  3. Created new element metsHdr to handle metadata regarding METS document itself (analogous to TEI Header).  Moved CREATEDATE and LASTMODDATE attributes to metsHdr, and added new RECORDSTATUS attribute.  Added new subsidiary elements agent and altRecordID to metsHdr.  4. Made CREATEDATE and LASTMODDATE attributes type xsd:dateTime to allow more precise recording of when work was done.  5. Changed all attributes using data type of xsd:binary to xsd:base64Binary to conform to final W3C schema recommendations.  6. Cleaned up annotations/documentation." mets.xsd xlink.xsd
git tag gamma
rm mets.xsd

cp mets.zeta.02-08-02.xsd mets.xsd
git commit --author="$jerry" --date="2002-08-02 12:00" -m "epsilon version of Dec 19 had 8 changes from gamma, zeta has 2 more changes than epsilon" mets.xsd xlink.xsd
git tag zeta
rm mets.xsd


wget http://www.loc.gov/standards/mets/version11/mets.xsd
git commit --author="$jerry" --date="2002/06/03 12:00" -m "1. Add new structLink section for recording hyperlinks between media represented by structMap nodes. 2. Allow a <par> element to contain a <seq>" mets.xsd xlink.xsd

git tag v1.1
rm mets.xsd 

wget http://www.loc.gov/standards/mets/version12/mets.xsd
git commit --author="$jerry" --date="Dec. 27, 2002 12:00" -m "1. Add “USE” attribute to FileGrp, File, FLocat and FContent; 2. Make FLocat repeatable; 3. Have FContent mimic mdWrap in using separate binData/xmlData sections; 4. Copyright statement added; 5. Allow both FLocat and Fcontent in single file element; 6. Allow behaviorSec elements to group through GROUPID attribute; 7. allow descriptive and administrative metadata sections to be grouped through GROUPID attribute; 8. allow <file> element to point to descriptive metadata via DMDID attribute; 9. allow descriptive metadata and all forms of administrative metadata to point to administrative metadata via ADMID attribute; 10. CREATED and STATUS attributes added to all desc. and adm. metadata sections; and 11. clean up documentation in elements to reflect reality." mets.xsd
git tag v1.2
rm mets.xsd 

wget http://www.loc.gov/standards/mets/version13/mets.xsd
git commit --author="$jerry" --date="May 8, 2003 12:00" -m "1. Change '2. OBJID: a primary identifier assigned to the original source document' to '2. OBJID: a primary identifier assigned to the METS object.' 2. Add MODS to MDTYPEs. 3. Modify <file> attributes so that instead of just CHECKSUM we have CHECKSUM and CHECKSUMTYPE, where CHECKSUMTYPE is a controlled vocabulary as follows: HAVAL, MD5, SHA-1, SHA-256, SHA-384, SHA-512, TIGER, WHIRLPOOL 4.Alter BehaviorSec to make it recursive, and add a new behavior element to wrap mechanism and interfaceDef elements." mets.xsd
git tag v1.3
rm mets.xsd xlink.xsd

wget http://www.loc.gov/standards/mets/version14/mets.xsd
wget http://www.loc.gov/standards/mets/version14/xlink.xsd
git commit --author="$jerry" --date="May 1, 2004 12:00" -m "1. Moved attribute documentation out of element documentation (thank you, Brian Tingle). 2. New CONTENTIDS attribute (and URIs simpleType) added to div, fptr, mptr and area elements for mapping MPEG21 DII Identifier values 3. XLink namespace URI changed to conform with XLink recommendation. 4. ID Attribute added to FContent. 5. ID Attribute addedt to structLink. 6. ID Attribute added to smLink. 7. 'LOM' added as metadata type." mets.xsd xlink.xsd
git tag v1.4
rm mets.xsd xlink.xsd

wget http://www.loc.gov/standards/mets/version15/mets.xsd
wget http://www.loc.gov/standards/mets/version15/xlink.xsd
git commit --author="$jerry" --date="April 12, 2005 12:00" -m "1. Made file element recursive to deal with PREMIS Onion Layer model and support XFDU-ish unpacking specification. 2. Add <stream> element beneath <file> to allow linking of metadata to subfile structures. 3. Modify structLink TO and FROM attributes to put them in XLink namespace. 4. Make processContents 'lax' for all xsd:any elements." mets.xsd xlink.xsd
git tag v1.5
rm mets.xsd 

wget http://www.loc.gov/standards/mets/version16/mets.xsd
git commit --author="$brian" --date="10/18/2006 12:00" -m "1. add ID to stream and transformFile 2. add ADMID to metsHdr 3. make smLink/@xlink:to and smLink/@xlink:from required" mets.xsd
git tag v1.6
rm mets.xsd 

git rm xlink.xsd  # moved to use same xlink.xsd as MODS

wget http://www.loc.gov/standards/mets/version17/mets.xsd
git commit --author="$brian" --date="October 16, 2007 12:00" -m "1. create parType complex type to allow a seq to contain a par 2. create FILECORE attribute group with MIMETYPE, SIZE, CHECKSUM, CHECKSUMTYPE; change fileType, mdWrapType and mdRefType use the attribute group, so mdType and mdRef end up with new SIZE, CHECKSUM, and CHECKSUMTYPE attributes (file does not change)" mets.xsd xlink.xsd
git tag v1.7
rm mets.xsd 

wget http://www.loc.gov/standards/mets/version18/mets.xsd
git commit --author="$rick" --date="April 1, 2009 12:00" -m "1. Add CRC32, Adler-32, MNP to the enumerated values constraining CHECKSUMTYPE to align with MIX messageDigestAlgorithm constraints. 2. Add TEXTMD and METSRIGHTS to the enumeration values constraining MDTYPE. 3. Add an MDTYPEVERSION attribute as a companion to the MDTYPE attribute in the mdRef and mdWrap elements.	 4. ID and STRUCTID attributes on the behavior element made optional. Depending on whether the behavior applies to a transformFile element or div elements in the structMap, only one or the other of the attributes would pertain. 5. Documentation aligned with the METS Primer, and corrected. 6. xml:lang="en" atttribute value added to every <documentation> element 7. xlink:extendedLink support added to the <structLink> element by means of a new <smLinkGrp> element, and its child <smLocatorLink> and <smArcLink> elements." mets.xsd
git tag v1.8
rm mets.xsd 

wget http://www.loc.gov/standards/mets/version19/mets.xsd
git commit --author="$rick" --date="February 1, 2010 12:00" -m 'Changes: 1. Added a <metsDocumentID> element to the <metsHdr> for recording a unique identifier for the METS document itself where this is different from the OBJID, the identifier for the entire digital object represented by the METS document. 2. Added "ISO 19115:2003 NAP" to the enumerated values for the MDTYPE attribute in the METADATA attribute group. 3. Added "XPTR" to the enumerated values for the BETYPE attribute on the areaType data type 4. Added BEGIN, END and BETYPE attributes to the <file> and <stream> elements for specifying the location of a nested file or a stream within it`s parent file.' mets.xsd
git tag v1.9
rm mets.xsd 

wget http://www.loc.gov/standards/mets/mets.xsd
git commit --author="$tom" --date="March 1, 2012 12:00" -m "1. Added 'EAC-CPF' as potential metadata scheme to MDTYPE enumeration EAC-CPF = Encoded Archival Context - Corporate Bodies, Persons, and Families http://eac.staatsbibliothek-berlin.de/eac-cpf-schema.html" mets.xsd
git tag v1.9.1
