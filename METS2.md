# Metadata Encoding and Transmission Schema (METS) Version 2

## Introduction

METS, the Metadata Encoding & Transmission Standard, has been used for describing digital objects since 2001. The METS XML schema version 1.x (METS 1) is used both as an interchange and a storage format by numerous systems in the digital preservation space [^coptr] [^profiles]. A METS document can describe the files that make up a digital object, their structural relationship to each other, and include a variety of metadata about the digital object and its component files.

The METS Editorial Board is working on version 2 of the Metadata Encoding & Transmission Standard (METS), work which aims to make METS easier to use and implement. Version 2 simplifies the schema, makes it more consistent, and removes reliance on the outdated XLink standard. It aims to retain a clear path for migration from METS 1 for most use cases. In this document the METS Editorial Board presents details of the each change along with a variety of examples.

### Motivation

METS 1 has been largely stable for many years. No new elements have been added to the schema since 2010; changes since then have primarily been to allow new values for specific attributes and to allow arbitrary attributes to appear on a variety of elements (via `xsd:anyAttribute`)

Around 2011, the METS Editorial Board started exploring potential future directions for METS, areas where METS has been successful, and areas where METS has not been as successful[^reimagining-mets]. This work did not result in a new version of METS at that time. However, in recent years, the METS Editorial Board has been made aware of a variety of issues and incompatibilities related to the XLink schema used in METS 1[^xlink-issue]. After discussion, it became clear that the best solution to the XLink issues was to move forward with the design of a new major revision of METS that did not need to maintain strict backwards compatibility. This also enabled consideration of a more general overhaul of the METS schema, building on the earlier exploration in [^reimagining-mets].

The basic idea of this new version of METS (METS 2) is to make METS simpler and more flexible by removing rarely-used features and by improving consistency between its various parts. From the beginning of the design process, it was a goal to maintain the general concepts of METS, to continue to support the major use cases of METS, and to make it easy to adapt and migrate a large majority of existing uses of METS 1 to METS 2.

At the same time, the METS Editorial Board recognized that not all systems will migrate from METS 1 to METS 2. The METS 1 schema will continue to be available and will continue to be supported for the foreseeable future. In particular, implementations which rely on elements such as `<structLink>` and `<behaviorSec>` in METS 1 will continue to be supported with METS 1; if there are any bugs found, a new version of METS 1 could be released, but most effort from the Board will be on METS 2 going forwards.

Usage of every element and attribute was checked against registered METS profiles. Known problems and inconsistencies of METS 1 were discussed, and possible solutions were considered in terms of their fit with the overall concepts of METS. The result is a kind of "METS light", improving consistency and ease of implementation without giving up flexibility or  versatility.

### METS 1 status

The most recent update to the METS XML schema was version 1.12.1 in October 2019. The only change in this update was to reformat the version history comments in the schema as XML Schema documentation elements so that automated schema documentation tools would display that information. Prior to that, version 1.12 in May 2018 made a change to allow any XML attributes on the `<note>` and `<agent>` elements, based on a user request. No new elements have been added to the schema since 2010. Although METS 1 continues to be in wide use, the METS Editorial Board has not received any recent bug reports or requested changes to METS 1, apart from the aforementioned issues with XLink. The METS Editorial Board has concluded that METS 1 is stable, and moved its focus to discussing the evolution of METS.

METS 1 is used in many contexts. It regularly comes to the board's attention that new uses and local profiles are created for describing the transfer and storage of digital objects. In many of these use cases METS is used as the manifest file for the digital objects; the ability to add both descriptive and administrative metadata alongside the digital objects is highly appreciated. 

For METS 1, METS profiles are an important feature that allows implementers to describe a specific way of using METS. The METS profiles have been key in aiding others in how to use METS and served as reusable examples of how to implement METS. At the same time, the board is aware of the fact that not all uses and profiles being created are registered. In many cases METS users do not feel that their use is stable enough to register a profile; instead they want to do more testing and development before submitting a profile. The board still wants to encourage creators to register their METS profiles so others can benefit from their work.

## Changes in METS 2

In this section we describe the changes that have been made in METS 2.

### METS 2 schema

The changes in the METS 2 schema all serve to simplify usage by making the schema more consistent and by removing some rarely-used features. As METS 2 is not backwards-compatible with METS 1, there is a new namespace URI for the schema: http://www.loc.gov/METS/v2

METS 2 reorganizes the major sections of the METS file. It uses a parallel organization for all major sections of the METS file by:

* removing the `<structLink>` and `<behaviorSec>` sections entirely
* simplifying the `<dmdSec>` and `<amdSec>` metadata sections into a single `<mdSec>` section
* retaining `<fileSec>` largely as-is
* wrapping all `<structMap>` elements in a new `<structSec>` section

METS 2 also removes reliance on the XLink specification[^xlink-1.1] and removes most lists of allowed attribute values from the schema in favor of suggested external controlled vocabularies.

The details of each change and motivation behind each specific change are discussed below.

METS 2 is still in an early stage of development, but is now ready for discussion and feedback. The draft schema, generated documentation, and instructions for feedback are all available in GitHub at [https://github.com/mets/METS-schema](https://github.com/mets/METS-schema).


### Remove XLINK as separate schema

When METS 1 was first drafted in 2001, the XLink 1.0 specification was in the process of being adopted as a W3C recommendation[^xlink-1.0], and seemed promising for future adoption. In the intervening years, XLink has had little uptake. Although there was a 1.1 revision to the specification in 2010[^xlink-1.1], there is no browser support for XLink beyond basic XLinks in SVG, and schemas which used XLink in the past have moved away from it: notably, the SVG 2 candidate recommendation deprecates xlink attributes in favor of attributes defined locally to the schema[^svg-xlink], and both PREMIS 3 and EAD 3 drop XLink entirely in favor of schema-local attributes.[^premis-3] [^ead-3] 

The continued inclusion of XLink in METS, and more specifically the reference to an XLink XSD (https://www.loc.gov/standards/xlink/xlink.xsd) can also cause validation problems when using METS alongside other XML schemas that also reference XLink, but reference slightly different XLink XSD schemas published by W3C (http://www.w3.org/1999/xlink.xsd or https://www.w3.org/XML/2008/06/xlink.xsd).[^xlink-issue] This includes the current version of the Standard d'échange de données pour l'archivage (SEDA) schema from FranceArchives[^seda] as well as some versions of Open Geospatial Consortium (OGC) schemas.[^ogc]

METS 2 follows this trend by removing extended XLinks entirely, dropping references to the rarely-used XLink attributes `xlink:role`, `xlink:arcrole`, `xlink:title`, `xlink:show`, and `xlink:actuate`, and instead using a locally-defined LOCREF attribute in favor of the `xlink:href` attribute. The draft METS 2 schema also allows `LOCREF` to be any string, not just a URI as with `xlink:href` in METS 1. In practice the `xlink:href` attribute was used even when the location was not actually a URI -- for example, locally-defined identifiers, or relative paths defined without reference to a base URI. Changing the attribute name and type removes this potential semantic confusion.

<!-- TODO: Following comments from iPRES paper we should clarify the change
  from xlink to local attributes here, explain clearly what functionality
  around extended xlinks is removed, and include plenty of examples -->

<!-- TODO: add METS 1 / METS 2 examples before/after for FLocat/mptr -->

### Removal of value restrictions for attribute values

In METS 1, the schema restricts the values of several attributes, primarily "type" attributes. However, enumerating lists of values in the schema limits extensibility and flexibility for users, delays the availability of values for new standards, and adds to the proliferation of schema versions over time. With METS 1, implementers could use (for example) `MDTYPE="OTHER"` and provide an `OTHERMDTYPE` value, but this literally serves to "other" and devalue data types not explicitly approved by the METS Editorial Board. Although adopters can request new values, the overhead of evaluating and approving requests and releasing a new version of the schema means there is a significant delay between the request and the availability of the new term for use. With METS 2, recommended standards and values for these attributes will instead be documented externally to the schema itself, as was done for PREMIS 3.[^preservation-schemes] This will both reduce changes required to the schema and reduce the barrier to extending lists of possible attribute values. Initially, these recommended values will come from METS 1 and be published alongside the draft schema on GitHub. Before finalizing METS 2, we aim to publish these value lists using the same mechanism on the Library of Congress web site as for PREMIS 3.

Elements with attributes from which enumerated value lists will be removed in METS 2:

* `agent`: `ROLE`, `TYPE`
* `area`: `BETYPE`, `EXTTYPE`, `SHAPE`
* `file`: `CHECKSUMTYPE`
* `FLocat`: `LOCTYPE`
* `mdRef`: `LOCTYPE`, `MDTYPE`
* `mdWrap`: `MDTYPE`
* `mptr`: `LOCTYPE`
* `stream`: `BETYPE`
* `transformFile`: `TRANSFORMTYPE`

<!-- TODO: Note area@shape came from HTML & the restrictions there -->

Because enumerations will be removed from the METS schema, all attributes starting with `OTHER` are no longer needed and will be omitted from METS 2: `OTHERROLE`, `OTHERTYPE`, `OTHERMDTYPE`, and `OTHERLOCTYPE`.

### Removal of structLink and behaviorSec

Neither the `structLink` nor `behaviorSec` sections are included in METS 2. In looking at published profiles as well as Google and GitHub searches for these element names, we found that these sections are rarely used in METS 1.

As indicated in the METS schema documentation, the `<structLink>` element was added in METS 1.1 for recording hyperlinks between media represented by `<structMap>` nodes. These hyperlinks were represented by extended XLink objects that could be used to record links between `<structMap>` nodes separately from the structMap nodes themselves. The primary documented use case for `<structLink>` was to indicate links between web pages described in a METS object.[^structlink-email] However, in the intervening years the [Web ARChive (WARC)](https://iipc.github.io/warc-specifications/specifications/warc-format/warc-1.1/) file format has emerged as a standard way of capturing web archives, minimizing the need for METS to handle this use case. Likewise, XLink (especially extended links) did not come into widespread usage. Thus, METS 2 removes support for `<structLink>`, along with the XLink schema.

The `<behaviorSec>` element was added to the "epsilon" revision late in the design process of METS 1 to support referencing executable code from METS objects. This was primarily to support a use case for early versions of the [Fedora digital repository system](https://duraspace.org/fedora/).[^fedora-email] [^fedora-2-mets] Fedora has since moved away from the use of METS and XML in general, and this section has not been used widely or supported by other METS implementations.

### Changes in metadata sections

In METS 1 the metadata is recorded in purpose-specific sections and elements. Descriptive metadata for both discovery and management of the whole digital object or one of its components is recorded in section `<dmdSec>`. Multiple descriptive metadata sections are allowed so that descriptive metadata can be recorded for each separate item or component within the METS document. All forms of administrative metadata for management of the digital object are recorded in section `<amdSec>`. This parent section `<amdSec>` is separated into four sub-sections that accommodate technical metadata (`<techMD>`), intellectual property rights (`<rightsMD>`), analog/digital source metadata (`<sourceMD>`), and digital provenance metadata (`<digiprovMD>`). Multiple instances of the element `<amdSec>` can occur within a METS document and multiple instances of its subsections `<techMD>`, `<rightsMD>`, `<sourceMD>` and `<digiprovMD>` can occur in one `<amdSec>` element.

METS 2 makes all metadata sections more generic by using general elements `<mdSec>`, `<mdGrp>` and `<md>` following the hierarchy of the file section. The optional attribute @USE describes the purpose of the metadata in that element. All these elements can be referenced from file section, structural section and metadata sections using the general @MDID attribute instead of the more specific @DMDID and @ADMID attributes from METS 1. METS 2 does not prescribe a specific vocabulary or syntax for encoding metadata. These changes simplify the schema and in turn processing software while enhancing flexibility in the structuring of the metadata.

In METS 2, the metadata section `<mdSec>` contains all metadata pertaining to the digital object, its components and any original source material from which the digital object is derived. The optional `<mdGrp>` element allows grouping related kinds of metadata. This could be all metadata of a particular type, all metadata coming from a particular source, all metadata pertaining to a certain file or set of files, or any other relevant grouping; the `<mdGrp>` can then be referenced from an MDID attribute elsewhere. The `<md>` element records any kind of metadata about the METS object or a component thereof. As with metadata elements in METS 1, the `<md>` element can include the metadata inline with `<mdWrap>`, reference it in an external location via `<mdRef>`, or both. The `<mdSec>` element can contain any number of `<mdGrp>` elements which in turn contain any number of `<md>` elements, or it can include `<md>` elements directly if grouping is not needed. Another change is removing the attribute `XPTR` from element mdRef; any reference via XPointer can instead be included in the `LOCREF` attribute. 

As in METS 1, included or referenced metadata can be in any format, XML or otherwise. METS 2 replaces the varied element names with a USE attribute comparable to that on `<fileGrp>`. Values could include `DESCRIPTIVE`, `TECHNICAL`, `RIGHTS`, `SOURCE`, `PROVENANCE` to correspond to the `<dmdSec>`, `<techMD>`, `<rightsMD>`, `<sourceMD>`, and `<digiprovMD>` metadata sections available in METS 1, or could use any other value according to local needs.

#### Example for METS 1

```xml
<mets>
  ...
  <dmdSec>
  ...
  </dmdSec>
  <amdSec>
    <techMD>
    ...
    </techMD>
    <rightsMD>
    ...
    </rightsMD>
    <sourceMD>
    ...
    </sourceMD>
    <digiprovMD>
    ...
    </digiprovMD>
  </amdSec>
  ...
</mets>
```

#### Example for METS 2 preserving METS 1 semantics

```xml
<mets>
  ...
  <mdSec>
    <mdGrp USE="DESCRIPTIVE">
      <md USE="DESCRIPTIVE">
        ...
      </md>
    </mdGrp>
    <mdGrp USE="ADMINISTRATIVE">
      <md USE="TECHNICAL">
        ...
      </md>
      <md USE="RIGHTS">
        ...
      </md>
      <md USE="SOURCE">
        ...
      </md>
      <md USE="PROVENANCE">
        ...
      </md>
    </mdGrp>
  </mdSec>
    ...
</mets>
```

Example for METS 2 without mdGrp e.g. for a simple digital object

```xml
<mets>
  ...
  <mdSec>		
    <md USE="DESCRIPTIVE">
      ...
    </md>
    <md USE="DESCRIPTIVE">
      ...
    </md>		
    <md USE="RIGHTS">
      ...
    </md>
    <md USE="PROVENANCE">
      ...
    </md>		
  </mdSec>
    ...
</mets>
```


### Changes in file section

Both METS 1 and METS 2 include the file section `<fileSec>` that lists the files that comprise the digital object described in the METS document.

METS 1 supported hierarchical arrangement of files with nested file grouping (`<fileGrp>`) and allowed mixing both `<fileGrp>` and `<file>` elements. However, this may result in structural information being added to the file section. The file section should be used for listing a manifest of included files (and streams, if needed), but  any structural information should be handled by a structural section. To guide in this direction, nested file grouping is not allowed in METS 2, and only one-level for grouping of files is optionally allowed. This makes the file section hierarchy consistent with the metadata section (`<mdSec>`), and it simplifies the schema and processing software.

Although nested file grouping is not allowed in METS 2, `<file>` elements themselves may still be nested, as in METS 1. This is often useful for representing the physical structure of archive formats such as `.zip`, etc.

A significant change in METS 2 compared to METS 1 is the removal of the XLink structure. In the file section, this applies to the `<FLocat>` element. In METS 2, the location of the file is not given with the `xlink:href` attribute (as given in METS 1), but with a separate `LOCREF` attribute defined in the METS 2 schema. All other attributes of XLink namespace are also removed. The attribute pair `LOCTYPE` and `LOCREF` must be used when using a reference of any kind. The `LOCTYPE` is used to record the type of the reference (e.g. URL, database, relative path), and the actual reference is given in `LOCREF` attribute. As with other "type" attributes in METS 2, there is no enumerated list of allowed values (see section above) in `LOCTYPE`, so `OTHERLOCTYPE` attribute is removed.

In this METS 1 example, the `dprov-001` metadata section applies to all nested `<fileGrp>` elements:

```xml
<mets ...>
  ...
  <fileSec>
    <fileGrp ADMID="dprov-001" USE="Images">
      <fileGrp USE="Original">
        <file ID="file-001" ADMID="tech-001">
          <FLocat LOCTYPE="URL" xlink:href="https://example.org/img001.tif"
                xlink:type="simple" />
        </file>
      </fileGrp>
      <fileGrp USE="Thumbnails">
        ...
      </fileGrp>
    </fileGrp>
    <fileGrp ADMID="dprov-002" USE="Documents">
      <file ID="file-doc-001" ADMID="tech-doc-001">
        <FLocat LOCTYPE="URL" xlink:href="https://example.org/doc001.pdf"
              xlink:type="simple" />
      </file>
    </fileGrp>
  </fileSec>
  ...
</mets>
```

In METS 2, there may be no more than one level of `<fileGrp>` elements, so the reference to `dprov-001` is repeated across multiple `<fileGrp>` elements:


```xml
<mets ...>
  ...
  <fileSec>
    <fileGrp MDID="dprov-001" USE="Original Images">
      <file ID="file-001" MDID="tech-001">
        <FLocat LOCTYPE="URL" LOCREF="https://example.org/img001.tif" />
      </file>
    </fileGrp>
    <fileGrp MDID="dprov-001" USE="Thumbnails">
      ...
    </fileGrp>
    <fileGrp MDID="dprov-002" USE="Documents">
      <file ID="file-doc-001" MDID="tech-doc-001">
        <FLocat LOCTYPE="URL" LOCREF="https://example.org/doc001.pdf" />
      </file>
    </fileGrp>
  </fileSec>
  ...
</mets>
```


As with `<mdSec>` and `<md>`, if there is no need for multiple groups, `<file>` elements may be added directly under the `<fileSec>` element:


```xml
<mets ...>
  ...
  <fileSec>
    <file ID="file-001" MDID="tech-001 dprov-001">
      <FLocat LOCTYPE="URL" LOCREF="https://example.org/img001.tif" />
    </file>
    ...
    <file ID="file-doc-001" MDID="tech-doc-001 dprov-002">
      <FLocat LOCTYPE="URL" LOCREF="https://example.org/doc001.pdf" />
    </file>
  </fileSec>
  ...
</mets>
```

Instead of repeating the references to `dprov-001` and `dprov-002` in `<file>` elements, another option would be to refer to `dprov-001` and `dprov-002` in `<div>` elements in a structural map. This `<div>` then in turn also includes references to the specific files:

```xml
<mets ...>
  ...
  <structSec>
    <structMap>
      <div>
        <div MDID="digiprov-001" TYPE="Images">
          <div TYPE="Master">
            <fptr FILEID="file-master-001" />
            <fptr FILEID="file-master-002" />
            ...
          </div>
          <div TYPE="Thumbnails">
            ...
          </div>
          ...
        </div>
        <div MDID="digiprov-002" TYPE="Documents">
          <fptr FILEID="file-doc-001" />
          ...
        </div>
        ...
      </div>
    </structMap>
  <structSec>
  ...
</mets>
```

### Changes in structural map

The structural map element (`<structMap>`) describes how all the digital objects found in the METS document relate to each other. There can potentially be multiple `<structMap>` elements to describe multiple arrangements of files -- for example, it could describe both a physical layout of files on disk as well as a logical arrangement of intellectual content. METS 2 adds a structSec element to contain all `<structMap>` elements; this makes structural information more consistent with the other major sections of the METS document. Although `<structMap>` was required in METS 1, `<structSec>` is optional in METS 2. Some use cases for METS do not require structural information: for example, a simple manifest of files transferred along with relevant metadata. There are no other changes to the `<structMap>` element itself or to its descendent elements; the `<structMap>` works well as-is for organizing and relating the files and metadata described by the METS document.

### Example for METS 1

In METS 1, all `<structMap>` elements are children of the root `<mets>` element.

```xml
<mets>
	...
  <structMap>
    ...
  </structMap>
  <structMap>
    ...
  </structMap>
</mets>
```

### Example for METS 2

In METS 2, all `<structMap>` elements are collected under a `<structSec>` element:
```xml
<mets>
  ...
  <structSec>
    <structMap>
      ...
    </structMap>
    <structMap>
      ...
    </structMap>
  </structSec>
</mets>	
```


## Examples

First, an example of a METS 1 object with two PDF files and corresponding MODS and PREMIS metadata:

```xml
<mets OBJID="01234567-0123-4567-0123-456789abcdef"
      PROFILE="my-profile"
      xmlns="http://www.loc.gov/METS/"
      xmlns:xlink="http://www.w3.org/1999/xlink">
  <metsHdr CREATEDATE="2022-07-06T14:05:00">
     <agent ROLE="CREATOR">
        <name>METS Editorial Board</name>
     </agent>
  </metsHdr>
  <dmdSec ID="md-001" CREATED="2022-07-06T14:00:00">
     <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
            MDTYPE="MODS" MDTYPEVERSION="3.7" LOCTYPE="URL"
            xlink:type="simple" xlink:href="http://example.org/mods1.xml" />
  </dmdSec>
  <amdSec>
     <techMD ID="md-002" CREATED="2022-07-06T14:01:00">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="f123456789abcdef0123456789abcde0"
               MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0" LOCTYPE="URL"
               xlink:type="simple" xlink:href="http://example.org/object1.xml" />
     </techMD>
     <techMD ID="md-003" CREATED="2022-07-06T14:02:00">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="e123456789abcdef0123456789abcde1"
               MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0" LOCTYPE="URL"
               xlink:type="simple" xlink:href="http://example.org/object2.xml" />
     </techMD>
     <digiprovMD ID="md-004" CREATED="2022-07-06T14:03:00">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="d123456789abcdef0123456789abcde2"
               MDTYPE="PREMIS:EVENT" MDTYPEVERSION="3.0" LOCTYPE="URL"
               xlink:type="simple" xlink:href="http://example.org/event1.xml" />
     </digiprovMD>
  </amdSec>
  <fileSec>
     <fileGrp>
        <file ID="file-001" ADMID="md-002">
           <FLocat LOCTYPE="URL" xlink:type="simple"
                   xlink:href="http://example.org/myfile1.pdf" />
        </file>
        <file ID="file-002" ADMID="md-003">
           <FLocat LOCTYPE="URL" xlink:type="simple"
                   xlink:href="http://example.org/myfile2.pdf" />
        </file>
     </fileGrp>
  </fileSec>
  <structMap>
     <div DMDID="md-001" ADMID="md-004">
        <fptr FILEID="file-001" />
        <fptr FILEID="file-002" />
     </div>
  </structMap>
</mets>
```

Here is the same digital object expressed with METS 2; note in particular:

* the change to `<mdSec>` / `<md>`
* the use of `LOCREF` instead of `xlink:href`
* the omission of `<fileGrp>`
* the use of `<structSec>` to map the `<structMap>`

```xml
<mets OBJID="01234567-0123-4567-0123-456789abcdef"
      PROFILE="my-profile"
      xmlns="http://www.loc.gov/METS/v2">
  <metsHdr CREATEDATE="2022-07-06T14:05:00">
    <agent ROLE="CREATOR">
      <name>METS Editorial Board</name>
    </agent>
  </metsHdr>
  <mdSec>
    <md USE="DESCRIPTIVE" ID="md-001" CREATED="2022-07-06T14:00:00">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="MODS" MDTYPEVERSION="3.7"
           LOCTYPE="URL" LOCREF="http://example.org/mods1.xml" />
    </md>
    <md USE="TECHNICAL" ID="md-002" CREATED="2022-07-06T14:01:00">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="f123456789abcdef0123456789abcde0"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" LOCREF="http://example.org/object1.xml" />
    </md>
    <md USE="TECHNICAL" ID="md-003" CREATED="2022-07-06T14:02:00">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="e123456789abcdef0123456789abcde1"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" LOCREF="http://example.org/object2.xml" />
    </md>
    <md USE="PROVENANCE" ID="md-004" CREATED="2022-07-06T14:03:00">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="d123456789abcdef0123456789abcde2"
           MDTYPE="PREMIS:EVENT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" LOCREF="http://example.org/event1.xml" />
    </md>
  </mdSec>
  <fileSec>
    <file ID="file-001" MDID="md-002">
      <FLocat LOCTYPE="URL" LOCREF="http://example.org/myfile1.pdf" />
    </file>
    <file ID="file-002" MDID="md-003">
      <FLocat LOCTYPE="URL" LOCREF="http://example.org/myfile2.pdf" />
    </file>
  </fileSec>
  <structSec>
    <structMap>
      <div MDID="md-001 md-004">
        <fptr FILEID="file-001" />
        <fptr FILEID="file-002" />
      </div>
    </structMap>
  </structSec>
</mets>
```

Here is a more complex METS 1 example of a digital object comprising a research data set; note in particular the multiple `<fileGrp>` and `<structMap>`
elements.

```xml
<mets OBJID="01234567-0123-4567-0123-456789abcdef"
    PROFILE="http://www.loc.gov/mets/profiles/my-profile.xml"
    xmlns="http://www.loc.gov/METS/"
    xmlns:xlink="http://www.w3.org/1999/xlink">
  <metsHdr CREATEDATE="2022-07-06T14:05:00">
    <agent ROLE="CREATOR">
      <name>METS Editorial Board</name>
    </agent>
  </metsHdr>
  <dmdSec ID="dmd-001">
    <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
         MDTYPE="DC" MDTYPEVERSION="1.1"
         LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/mymetadata/dc.xml" />
  </dmdSec>
  <amdSec>
    <techMD ID="tech-001">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech1.xml" />
    </techMD>
    <techMD ID="tech-002">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech2.xml" />
    </techMD>
    <techMD ID="tech-003">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech3.xml" />
    </techMD>
    <techMD ID="tech-004">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech4.xml" />
    </techMD>
    <techMD ID="tech-005">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech5.xml" />
    </techMD>
    <techMD ID="tech-006">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech6.xml" />
    </techMD>
    <techMD ID="tech-007">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech7.xml" />
    </techMD>
    <techMD ID="tech-008">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech8.xml" />
    </techMD>
    <techMD ID="tech-009">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech9.xml" />
    </techMD>
    <techMD ID="tech-010">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/tech10.xml" />
    </techMD>
    <digiprovMD ID="event-001">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:EVENT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/creation_event1.xml" />
    </digiprovMD>
    <digiprovMD ID="agent-001">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:AGENT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/creation_agent1.xml" />
    </digiprovMD>
    <digiprovMD ID="event-002">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:EVENT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/normalization_event1.xml" />
    </digiprovMD>
    <digiprovMD ID="agent-002">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:AGENT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/normalization_agent1.xml" />
    </digiprovMD>
    <digiprovMD ID="event-003">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:EVENT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/normalization_event2.xml" />
    </digiprovMD>
    <digiprovMD ID="agent-003">
      <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
           MDTYPE="PREMIS:AGENT" MDTYPEVERSION="3.0"
           LOCTYPE="URL" xlink:type="simple"
           xlink:href="http://example.org/mymetadata/normalization_agent2.xml" />
    </digiprovMD>
  </amdSec>
  <fileSec>
    <fileGrp USE="computer-readable">
      <file ID="file-001" ADMID="tech-001 event-002 agent-002">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/data/measurements.xyz" />
      </file>
      <file ID="file-002" ADMID="tech-002 event-002 agent-002">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/data/measurements.csv" />
      </file>
      <file ID="file-003" ADMID="tech-003">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/data/analysis.csv" />
      </file>
      <file ID="file-004" ADMID="tech-004">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/data/device.conf" />
      </file>
      <file ID="file-005" ADMID="tech-005">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/code/myanalysis.java" />
      </file>
    </fileGrp>
    <fileGrp USE="human-readable">
      <file ID="file-006" ADMID="tech-006 event-003 agent-003">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/documents/publication.docx" />
      </file>
      <file ID="file-007" ADMID="tech-007 event-003 agent-003">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/documents/publication.pdf" />
      </file>
      <file ID="file-008" ADMID="tech-008">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/documents/research_plan.txt" />
      </file>
      <file ID="file-009" ADMID="tech-009">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/README.txt" />
      </file>
      <file ID="file-010" ADMID="tech-010">
        <FLocat LOCTYPE="URL" xlink:type="simple"
         xlink:href="http://example.org/myresearch/license.txt" />
      </file>
    </fileGrp>
  </fileSec>
  <structMap TYPE="LOGICAL">
    <div TYPE="RESEARCH" DMDID="dmd-001" ADMID="event-001 agent-001">
      <div TYPE="SOURCE">
        <fptr FILEID="file-001" />
        <fptr FILEID="file-002" />
      </div>
      <div TYPE="OUTCOME">
        <fptr FILEID="file-003" />
      </div>
      <div TYPE="CONFIGURATION">
        <fptr FILEID="file-004" />
      </div>
      <div TYPE="METHOD">
        <fptr FILEID="file-005" />
      </div>
      <div TYPE="PUBLICATION">
        <fptr FILEID="file-006" />
        <fptr FILEID="file-007" />
      </div>
      <div TYPE="DOCUMENTATION">
        <fptr FILEID="file-008" />
        <fptr FILEID="file-009" />
      </div>
      <div TYPE="RIGHTS">
        <fptr FILEID="file-010" />
      </div>
    </div>
  </structMap>
  <structMap TYPE="PHYSICAL">
    <div TYPE="directory" LABEL="myresearch" DMDID="dmd-001"
        ADMID="event-001 agent-001">
      <fptr FILEID="file-009" />
      <fptr FILEID="file-010" />
      <div TYPE="directory" LABEL="data">
        <fptr FILEID="file-001" />
        <fptr FILEID="file-002" />
        <fptr FILEID="file-003" />
        <fptr FILEID="file-004" />
      </div>
      <div TYPE="directory" LABEL="code">
        <fptr FILEID="file-005" />
      </div>
      <div TYPE="directory" LABEL="documents">
        <fptr FILEID="file-006" />
        <fptr FILEID="file-007" />
        <fptr FILEID="file-008" />
      </div>
    </div>
  </structMap>
</mets>
```

Expressed in METS 2, the changes are much the same as for the simpler digital object. Note in this case the `<fileGrp>` elements are preserved, and the multiple `<structMap>` elements are nested under `<structSec>`.

```xml
<mets OBJID="01234567-0123-4567-0123-456789abcdef"
    PROFILE="my-profile"
    xmlns="http://www.loc.gov/METS/v2">
  <metsHdr CREATEDATE="2022-07-06T14:05:00">
    <agent ROLE="CREATOR">
      <name>METS Editorial Board</name>
    </agent>
  </metsHdr>
  <mdSec>
    <mdGrp USE="DESCRIPTIVE">
      <md USE="DESCRIPTIVE" ID="dmd-001">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
         MDTYPE="DC" MDTYPEVERSION="1.1"
         LOCTYPE="URL"
         LOCREF="http://example.org/mymetadata/dc.xml" />
      </md>
    </mdGrp>
    <mdGrp USE="ADMINISTRATIVE">
      <md USE="TECHNICAL" ID="tech-001">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech1.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-002">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech2.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-003">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech3.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-004">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech4.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-005">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech5.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-006">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech6.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-007">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech7.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-008">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech8.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-009">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech9.xml" />
      </md>
      <md USE="TECHNICAL" ID="tech-010">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/tech10.xml" />
      </md>
      <md USE="PROVENANCE" ID="event-001">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:EVENT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/creation_event1.xml" />
      </md>
      <md USE="PROVENANCE" ID="agent-001">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:AGENT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/creation_agent1.xml" />
      </md>
      <md USE="PROVENANCE" ID="event-002">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:EVENT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/normalization_event1.xml" />
      </md>
      <md USE="PROVENANCE" ID="agent-002">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:AGENT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/normalization_agent1.xml" />
      </md>
      <md USE="PROVENANCE" ID="event-003">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:EVENT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/normalization_event2.xml" />
      </md>
      <md USE="PROVENANCE" ID="agent-003">
        <mdRef CHECKSUMTYPE="MD5" CHECKSUM="0123456789abcdef0123456789abcdef"
             MDTYPE="PREMIS:AGENT" MDTYPEVERSION="3.0"
             LOCTYPE="URL"
             LOCREF="http://example.org/mymetadata/normalization_agent2.xml" />
      </md>
    </mdGrp>
  </mdSec>
  <fileSec>
    <fileGrp USE="computer-readable">
      <file ID="file-001" MDID="tech-001 event-002 agent-002">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/data/measurements.xyz" />
      </file>
      <file ID="file-002" MDID="tech-002 event-002 agent-002">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/data/measurements.csv" />
      </file>
      <file ID="file-003" MDID="tech-003">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/data/analysis.csv" />
      </file>
      <file ID="file-004" MDID="tech-004">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/data/device.conf" />
      </file>
      <file ID="file-005" MDID="tech-005">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/code/myanalysis.java" />
      </file>
    </fileGrp>
    <fileGrp USE="human-readable">
      <file ID="file-006" MDID="tech-006 event-003 agent-003">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/documents/publication.docx" />
      </file>
      <file ID="file-007" MDID="tech-007 event-003 agent-003">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/documents/publication.pdf" />
      </file>
      <file ID="file-008" MDID="tech-008">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/documents/research_plan.txt" />
      </file>
      <file ID="file-009" MDID="tech-009">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/README.txt" />
      </file>
      <file ID="file-010" MDID="tech-010">
        <FLocat LOCTYPE="URL"
         LOCREF="http://example.org/myresearch/license.txt" />
      </file>
    </fileGrp>
  </fileSec>
  <structSec>
    <structMap TYPE="LOGICAL">
      <div TYPE="RESEARCH" MDID="dmd-001 event-001 agent-001">
        <div TYPE="SOURCE">
          <fptr FILEID="file-001" />
          <fptr FILEID="file-002" />
        </div>
        <div TYPE="OUTCOME">
          <fptr FILEID="file-003" />
        </div>
        <div TYPE="CONFIGURATION">
          <fptr FILEID="file-004" />
        </div>
        <div TYPE="METHOD">
          <fptr FILEID="file-005" />
        </div>
        <div TYPE="PUBLICATION">
          <fptr FILEID="file-006" />
          <fptr FILEID="file-007" />
        </div>
        <div TYPE="DOCUMENTATION">
          <fptr FILEID="file-008" />
          <fptr FILEID="file-009" />
        </div>
        <div TYPE="RIGHTS">
          <fptr FILEID="file-010" />
        </div>
      </div>
    </structMap>
    <structMap TYPE="PHYSICAL">
      <div TYPE="directory" LABEL="myresearch" MDID="dmd-001 event-001 agent-001">
        <fptr FILEID="file-009" />
        <fptr FILEID="file-010" />
        <div TYPE="directory" LABEL="data">
          <fptr FILEID="file-001" />
          <fptr FILEID="file-002" />
          <fptr FILEID="file-003" />
          <fptr FILEID="file-004" />
        </div>
        <div TYPE="directory" LABEL="code">
          <fptr FILEID="file-005" />
        </div>
        <div TYPE="directory" LABEL="documents">
          <fptr FILEID="file-006" />
          <fptr FILEID="file-007" />
          <fptr FILEID="file-008" />
        </div>
      </div>
    </structMap>
  </structSec>
</mets>
```

## METS Profiles

For METS 1 one important feature has been the METS Profiles which allows the users to describe their use. It has been possible to register the profile and get it published at loc.gov so others can reuse it. What can be noticed is that there are more profiles around than have been registered. In many cases a registration does not occur due to the creator not feeling ready with the profile and wanting to fine tune and then ends up with never registering it.

#### Statistics
Registered profiles, 46.
Unregistered profiles: While it is difficult to count the true number of unregistered profiles, it seems likely there are more unregistered profiles in use than registered ones. A search in Google with `xsi:schemaLocation="http://www.loc.gov/METS_Profile/v2”` yields around 360 results covering both METS profiles and mentionings of the schema. A search of GitHub for `http://www.loc.gov/METS_Profile/` yields 213 results. These counts include both registered and unregistered profiles.

#### METS Profiles for METS 2
There continues to be value in a standard mechanism for documenting usage in METS; it is helpful both for local system documentation as well as for interchange of METS documents.

While the existing METS profile schema is not directly machine-actionable, there are use cases where Schematron rules for validation reference documentation from METS profiles expressed in XML. (TODO: reference this example Karin provided?)

Thus, we plan to release a new version of the METS profile schema that matches the changes made to METS 2. At a minimum, this includes:
* removing reliance on the XLink schema
* updating the `<structural_requirements>` section to align with the major sections in METS 2.

Other work around METS profiles could include:

* A way to format METS profiles in a more readable format. For the profiles there was a transformation available that showed it in a "pretty" way. This transformation was a student work, has not been maintained, and does not working with the current profile schema. (TODO: reference to this transformation?)
* Additional guidance and examples of integrating METS profiles with Schematron rules for validation.
* Templates for textual versions of METS profiles: it may be simpler in many cases to produce a plain-text version (i.e. not XML) documentation of a given METS use case. Templates for this may aid in documenting the use of METS when there is no immediate benefit from the XML expression of the profile.

## Conclusion and Future Work

As we work through the process of finalizing METS 2, there are a number of remaining tasks. First and foremost, we seek feedback on the draft METS 2 schema. We welcome feedback (*BY A MECHANISM TBD*). In particular, we are interested in:
* whether existing uses of METS 1 can be migrated to METS 2, and (assuming uptake in the community) whether that would seem of value
* whether METS 2 seems more straightforward to implement than METS 1
* etc... (*TBD what other feedback would be useful*)

In addition to gathering feedback, there are several supporting tools and documents we plan to produce:

### Controlled Vocabularies

As mentioned [[METS2 white paper#Removal of value restrictions for attribute values|above]], we will publish a list of recommended values for the attributes that had enumerated value restrictions in METS 1.

### Sample Transformation from METS 1 to METS 2

We plan to produce a sample XSLT transformation to aid in migration from METS 1 to METS 2. This may not meet every need, but it is our goal to produce a transformation that covers most existing METS 1 use cases.

### Updated Documentation

There is significant supporting documentation for METS 1 that will need to be updated for METS 2. In the near term, we plan to update the [METS overview and tutorial](https://github.com/mets/wiki/wiki/01-Meeting-Agendas-and-Notes); longer-term, we will update the [METS Primer](https://github.com/mets/wiki/wiki/01-Meeting-Agendas-and-Notes).

## References

[^coptr]: METS (Metadata Encoding and Transmission Standard), Community Owned digital Preservation Tool Registry (COPTR), June 9, 2021. https://coptr.digipres.org/index.php/METS_(Metadata_Encoding_and_Transmission_Standard)

[^profiles]: METS Profiles, METS Editorial Board, 2017. https://www.loc.gov/standards/mets/mets-registered-profiles.html

[^reimagining-mets]: Reimagining METS: An Exploration for Discussion, METS Editorial Board, 2011. https://bit.ly/3Coy8xy

[^xlink-issue]: T. Habing, et al, "Primer Xlink Issue", 2019. https:// github.com/mets/METS-board/issues/19

[^xlink-1.0]: S. DeRose, E. Maler, D. Orchard, "XML Linking Language (XLink) Version 1.0", W3C, 2001. https://www.w3.org/TR/2001/REC-xlink-20010627/

[^xlink-1.1]: S. DeRose, E. Maler, D. Orchard, N. Walsh, "XML Linking Language (XLink) Version 1.1", W3C, 2010. https://www.w3.org/TR/xlink11/

[^svg-xlink]: A. Bellamy-Royds, et al, "Scalable Vector Graphics (SVG) 2" section 16.1.6 "Deprecated XLink URL reference attributes", W3C, 2018 https://www.w3.org/TR/SVG2/linking.html#XLinkRefAttrs

[^premis-3]: R. Denenberg, "PREMIS Preservation Metadata XML Schema Version 3.0", section "changes in version 3.0", 2016. https://www.loc.gov/standards/premis/v3/premis-v3-0.xsd

[^ead-3]: Encoded Archival Description Tag Library - ver. EAD3, preface, Soc. Amer. Arch, 2019. https://www.loc.gov/ead/EAD3taglib/EAD3.html

[^seda]: Standard d'échange de données pour l'archivage (SEDA), FranceArchives, June 2018. https://francearchives.fr/seda/ 

[^ogc]: "OGC Xlink Policy and timeline to move to XLink 1.1", Open Geospatial Consortium, April 2012, https://www.ogc.org/blog/1597

[^preservation-schemes]: Preservation Schemes (all), Library of Congress. https://id.loc.gov/vocabulary/preservation.html

[^structlink-email]: J. McDonough, "Question regarding StructMap and StructLink." METS Listserv, 2004. https://listserv.loc.gov/cgi-bin/wa?A2=ind0402&L=METS&P=R1131

[^fedora-email]: J. McDonough, "METS Meeting Summary." METS Listserv, 2001. https://listserv.loc.gov/cgi-bin/wa?A2=ind0111&L=METS&P=R2489

[^fedora-2-mets]: D. Davis, "Rules for Encoding Ingest Packages in METS", Fedora Repository 2 Documentation. June, 2008. https://duraspace.org/archive/fedora/files/documentation/2.2.4/index.html

