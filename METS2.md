# Metadata Encoding and Transmission Schema (METS) Version 2

## Introduction

METS, the Metadata Encoding & Transmission Standard, has been used for describing digital objects since 2001. The METS XML schema version 1.x (METS 1) is used both as an interchange and a storage format by numerous systems in the digital preservation space [^coptr] [^profiles]. A METS document can describe the files that make up a digital object, their structural relationship to each other, and include a variety of metadata about the digital object and its component files.

The METS Editorial Board is working on version 2 of the Metadata Encoding & Transmission Standard (METS), work which aims to make METS easier to use and implement. Version 2 simplifies the schema, makes it more consistent, and removes reliance on the outdated XLink standard. It aims to retain a clear path for migration from METS 1 for most use cases. In this document the METS Editorial Board presents details of the each change along with a variety of examples.

### Motivation

METS 1 has been largely stable for many years. No new elements have been added to the schema since 2010; changes since then have primarily been to allow new values for specific attributes and to allow arbitrary attributes to appear on a variety of elements (via `xsd:anyAttribute`). The most recent update to the METS XML schema was version 1.12.1 in October 2019. The only change in this update was to reformat the version history comments in the schema as XML Schema documentation elements so that automated schema documentation tools would display that information.

Around 2011, the METS Editorial Board started exploring potential future directions for METS, areas where METS has been successful, and areas where METS has not been as successful[^reimagining-mets]. This work did not result in a new version of METS at that time. However, in recent years, the METS Editorial Board has been made aware of a variety of issues and incompatibilities related to the XLink schema used in METS 1[^xlink-issue]. Although METS 1 continues to be in wide use, the METS Editorial Board has not received any recent bug reports or requested changes to METS 1 apart from the issues with XLink.  After discussion, it became clear that the best solution to the XLink issues was to move forward with the design of a new major revision of METS that did not need to maintain strict backwards compatibility. This also enabled consideration of a more general overhaul of the METS schema, building on the earlier exploration in [^reimagining-mets].

Since METS 1 was released in 2001, there have been a variety of other standardization efforts related to describing digital objects, some of which overlap with the functionality of METS. Likewise, other data representations and encodings besides XML have gained popularity, such as linked data and JSON.  Many of these other standardization efforts cover data encodings outside XML. This is useful for validating both the wrapper format (METS) and other embedded XML formats. Some examples include the Portland Common Data Model (PCDM)[^pcdm] and the International Image Interoperability Framework (IIIF)[^iiif]. PCDM is focused on describing digital objects via RDF/linked data, while METS is an XML representation. IIIF is focused primarily on delivering and describing digitized images; METS is often used for this purpose as well, but is considerably more general. Other standards such as BagIt[^bagit]  and the Oxford Common Filesystem Layout (OCFL)[^ocfl] standardize manifests and directory layouts for digital objects; METS complements these standards by providing a way to describe structure and to link content with metadata. XML is still used widely, however; we believe a representation of digital objects in XML continues to have value, and that these other standards complement rather than replace METS. In addition, XML has standardized, mature, and widely-available mechanisms for validation against schemas, including against multiple schemas in the same document. Overall, METS remains well suited to description of structure and ordering -- while possible with linked data, it can be significantly more cumbersome to represent and process -- as well as for storing and validating XML metadata about digital objects along with the manifest. 

The design process for this new version of METS (METS 2) builds on and reinforces these strengths. The overall idea of METS 2 is to make METS simpler and more flexible by removing rarely-used features and by improving consistency between its various parts. From the beginning of the design process, it was a goal to maintain the general concepts of METS, to continue to support the major use cases of METS, and to make it easy to adapt and migrate a large majority of existing uses of METS 1 to METS 2.

At the same time, the METS Editorial Board recognized that not all systems will migrate from METS 1 to METS 2. The METS 1 schema will continue to be available and will continue to be supported for the foreseeable future. In particular, implementations which rely on elements such as `<structLink>` and `<behaviorSec>` in METS 1 will continue to be supported with METS 1; if there are any bugs found, a new version of METS 1 could be released, but most effort from the Board will be on METS 2 going forwards.

Usage of every element and attribute was checked against registered METS profiles[^profiles]. Known problems and inconsistencies of METS 1 were discussed, and possible solutions were considered in terms of their fit with the overall concepts of METS. The result is a kind of "METS light", improving consistency and ease of implementation without giving up flexibility or  versatility.

Once the METS 2 schema is finalized and published, the METS Editorial Board does not expect to consider further backwards-incompatible changes in the near future. The current work on METS 2 covers all potential changes that have been discussed to date.

## Changes in METS 2

In this section we describe the changes that have been made in METS 2.

### METS 2 schema

The changes in the METS 2 schema all serve to simplify usage by making the schema more consistent and by removing some rarely-used features. As METS 2 is not backwards-compatible with METS 1, there is a new namespace URI for the schema: http://www.loc.gov/METS/v2

METS 2 reorganizes the major sections of the METS file. It uses a parallel organization for all major sections of the METS file by:

* removing the `<structLink>` and `<behaviorSec>` sections entirely
* simplifying the `<dmdSec>` and `<amdSec>` metadata sections into a single `<mdSec>` section, with the ability to group metadata with the `<mdGrp>` element
* retaining `<fileSec>` largely as-is, but disallowing nested `<fileGrp>` elements
* wrapping all `<structMap>` elements in a new `<structSec>` section

METS 2 also removes reliance on the XLink specification[^xlink-1.1] and removes all lists of allowed attribute values from the schema in favor of suggested external controlled vocabularies.

The details of each change and motivation behind each specific change are discussed below.

METS 2 is still in an early stage of development, but is now ready for discussion and feedback. The draft schema, generated documentation, and instructions for feedback are all available in GitHub at [https://github.com/mets/METS-schema](https://github.com/mets/METS-schema).

### What isn't changing

Although the overall file organization is somewhat different in METS 2, many elements in METS 1 remain largely unchanged in METS 2, and much of the functionality works in essentially the same way:

* The `<metsHdr>` section is retained essentially as-is.
* Metadata is still included with `<mdWrap>` or referenced externally with `<mdRef>`. Likewise, while metadata is now referenced internally using the `MDID` attribute, this works in the same way as the `ADMID` and `DMDID` attributes in METS 1.
* The `<fileSec>` section is organized into groups and files in the same way as in METS 1 (although METS 2 does not allow nested `<fileGrp>` elements)
* `<structMap>` and its child elements function the same way in METS 2 as they do in METS 1.

### Remove XLINK as separate schema

When METS 1 was first drafted in 2001, the XLink 1.0 specification was in the process of being adopted as a W3C recommendation[^xlink-1.0], and seemed promising for future adoption. In the intervening years, XLink has had little uptake. Although there was a 1.1 revision to the specification in 2010[^xlink-1.1], there is no browser support for XLink beyond basic XLinks in SVG, and schemas which used XLink in the past have moved away from it: notably, the SVG 2 candidate recommendation deprecates xlink attributes in favor of attributes defined locally to the schema[^svg-xlink], and both PREMIS 3 and EAD 3 drop XLink entirely in favor of schema-local attributes.[^premis-3] [^ead-3] 

The continued inclusion of XLink in METS, and more specifically the reference to an XLink XSD (https://www.loc.gov/standards/xlink/xlink.xsd) can also cause validation problems when using METS alongside other XML schemas that also reference XLink, but reference slightly different XLink XSD schemas published by W3C[^xlink-issue] (http://www.w3.org/1999/xlink.xsd or https://www.w3.org/XML/2008/06/xlink.xsd). This includes the current version of the Standard d'échange de données pour l'archivage (SEDA) schema from FranceArchives[^seda] as well as some versions of Open Geospatial Consortium (OGC) schemas.[^ogc]

METS 2 follows this trend by removing XLink entirely.  In METS 1, `<structLink>` and its descendent elements could include extended XLinks. This section is removed entirely in METS 2; see below.
In METS 1, all other XLinks in `<FLocat>`, `<mptr>`, and `<mdRef>` are simple XLinks, which can include the XLink attributes `xlink:role`, `xlink:arcrole`, `xlink:title`, `xlink:show`, and `xlink:actuate`. These attributes are rarely used in METS 1 and not replaced in METS 2. The remaining XLink attribute (and the one primarily used) in METS 1 is `xlink:href`. Instead of the `xlink:href` attribute, METS 2 uses a `LOCREF` attribute defined in the schema itself. The draft METS 2 schema also allows `LOCREF` to be any string, not just a URI as with `xlink:href` in METS 1. In practice the `xlink:href` attribute was used even when the location was not actually a URI -- for example, locally-defined identifiers, or relative paths defined without reference to a base URI. Changing the attribute name and type removes this potential semantic confusion. The `LOCTYPE` attribute carries over from METS 1, and can be used to to indicate whether `LOCREF` is a URI or some other kind of location.

In METS 1, a typical usage might be:

```xml
<FLocat LOCTYPE="URL" xlink:href="https://library.example/files/0001.pdf" />
```

In METS 2, the `xlink:href` attribute simply changes to `LOCREF`:
```xml
<FLocat LOCTYPE="URL" LOCREF="https://library.example/files/0001.pdf" />
```

In METS 1, a frequent usage (although not standardized) for representing files stored alongside the METS is:
```xml
<FLocat LOCTYPE="SYSTEM" xlink:href="0001.pdf"/>
```

Likewise, this can be represented in the same way as METS 2:
```xml
<FLocat LOCTYPE="SYSTEM" LOCREF="0001.pdf"/>
```

The XLink semantic attributes (`xlink:title`, `xlink:role`, and `xlink:arcrole`) are not widely used in METS 1. Other functionality present in both METS 1 and 2 such as the `USE` and `LABEL` attributes covers a similar purpose. For example, the semantic information conveyed in this METS 1 example:

```xml
<file ID="FILE001">
  <FLocat LOCTYPE="URL" xlink:href="http://library.example/files/0001.png" xlink:role="thumbnail" xlink:title="Example image"/>
</file>
```

could be represented in METS 2 as

```xml
<file ID="FILE001" USE="thumbnail">
  <FLocat LOCTYPE="URL" LOCREF="http://library.example/files/0001.png" />
</file>
```

alongside

```xml
<div LABEL="Example image">
  <fptr FILEID="FILE001"/>
</div>
```

The behavior attributes (`xlink:show` and `xlink:actuate`) do not seem to be used in practice in METS 1, and describe specifics of the way the application should interpret the METS document that are out of the scope of the purpose of METS 2.

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

Most of the allowed values in METS 1 for these attributes were specific to the METS standard. The exception is the `SHAPE` attribute; the allowed values originally came from the [`area@shape` attribute in HTML](https://www.w3.org/TR/2011/WD-html5-20110405/the-map-element.html#attr-area-shape). While many applications will continue using those values, the METS 2 schema itself does not enforce them.

Because enumerations will be removed from the METS schema, all attributes starting with `OTHER` are no longer needed and will be omitted from METS 2: `OTHERROLE`, `OTHERTYPE`, `OTHERMDTYPE`, and `OTHERLOCTYPE`.

### Removal of structLink and behaviorSec

Neither the `<structLink>` nor `<behaviorSec>` sections are included in METS 2. In looking at published profiles as well as Google and GitHub searches for these element names, we found that these sections are rarely used in METS 1.

As indicated in the METS schema documentation, the `<structLink>` element was added in METS 1.1 for recording hyperlinks between media represented by `<structMap>` nodes. These hyperlinks were represented by extended XLink objects that could be used to record links between `<structMap>` nodes separately from the structMap nodes themselves. The primary documented use case for `<structLink>` was to indicate links between web pages described in a METS object.[^structlink-email] However, in the intervening years the [Web ARChive (WARC)](https://iipc.github.io/warc-specifications/specifications/warc-format/warc-1.1/) file format has emerged as a standard way of capturing web archives, minimizing the need for METS to handle this use case. Likewise, XLink (especially extended links) did not come into widespread usage. Thus, METS 2 removes `<structLink>` and its descendent elements `<smLink>`, `<smLinkGrp>`, `<smArcLink>`, and `<smLocatorLink>`, along with the XLink schema.

The `<behaviorSec>` element was added to the "epsilon" revision late in the design process of METS 1 to support referencing executable code from METS objects. This was primarily to support a use case for early versions of the [Fedora digital repository system](https://duraspace.org/fedora/).[^fedora-email] [^fedora-2-mets] Fedora has since moved away from the use of METS and XML in general, and this section has not been used widely or supported by other METS implementations.

### Changes in metadata sections

In METS 1 the metadata is recorded in purpose-specific sections and elements. Descriptive metadata for both discovery and management of the whole digital object or one of its components is recorded in section `<dmdSec>`. Multiple descriptive metadata sections are allowed so that descriptive metadata can be recorded for each separate item or component within the METS document. All forms of administrative metadata for management of the digital object are recorded in section `<amdSec>`. This parent section `<amdSec>` is separated into four sub-sections that accommodate technical metadata (`<techMD>`), intellectual property rights (`<rightsMD>`), analog/digital source metadata (`<sourceMD>`), and digital provenance metadata (`<digiprovMD>`). Multiple instances of the element `<amdSec>` can occur within a METS document and multiple instances of its subsections `<techMD>`, `<rightsMD>`, `<sourceMD>` and `<digiprovMD>` can occur in one `<amdSec>` element.

METS 2 makes all metadata sections more generic by using general elements `<mdSec>`, `<mdGrp>` and `<md>` following the hierarchy of the file section. The optional attribute `USE` describes the purpose of the metadata in that element. All these elements can be referenced from file section, structural section and metadata sections using the general `MDID` attribute instead of the more specific `DMDID` and `ADMID` attributes from METS 1. METS 2 does not prescribe a specific vocabulary or syntax for encoding metadata. These changes simplify the schema and in turn processing software while enhancing flexibility in the structuring of the metadata.

In METS 2, the metadata section `<mdSec>` contains all metadata pertaining to the digital object, its components and any original source material from which the digital object is derived. The optional `<mdGrp>` element allows grouping related kinds of metadata. This could be all metadata of a particular type, all metadata coming from a particular source, all metadata pertaining to a certain file or set of files, or any other relevant grouping; the `<mdGrp>` can then be referenced from an `MDID` attribute elsewhere. The `<md>` element records any kind of metadata about the METS object or a component thereof. As with metadata elements in METS 1, the `<md>` element can include the metadata inline with `<mdWrap>`, reference it in an external location via `<mdRef>`, or both. The `<mdSec>` element can contain any number of `<mdGrp>` elements which in turn contain any number of `<md>` elements, or it can include `<md>` elements directly if grouping is not needed. Another change is removing the attribute `XPTR` from element `<mdRef>`; any reference via XPointer can instead be included in the `LOCREF` attribute. 

As in METS 1, included or referenced metadata can be in any format, XML or otherwise. METS 2 replaces the varied element names with a `USE` attribute comparable to that on `<fileGrp>`. Values could include `DESCRIPTIVE`, `TECHNICAL`, `RIGHTS`, `SOURCE`, `PROVENANCE` to correspond to the `<dmdSec>`, `<techMD>`, `<rightsMD>`, `<sourceMD>`, and `<digiprovMD>` metadata sections available in METS 1, or could use any other value according to local needs.

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

A significant change in METS 2 compared to METS 1 is the removal of the XLink structure. In the file section, this applies to the `<FLocat>` element. In METS 2, the location of the file is not given with the `xlink:href` attribute (as given in METS 1), but with a separate `LOCREF` attribute defined in the METS 2 schema. All other attributes of XLink namespace are also removed. The attribute pair `LOCTYPE` and `LOCREF` must be used when using a reference of any kind. The `LOCTYPE` is used to record the type of the reference (e.g. URL, database, relative path), and the actual reference is given in `LOCREF` attribute. As with other "type" attributes in METS 2, there is no enumerated list of allowed values (see section [above](#removal-of-value-restrictions-for-attribute-values)) in `LOCTYPE`, so `OTHERLOCTYPE` attribute is removed.

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

First, an example of a METS 1 object with two PDF files and corresponding MODS and PREMIS metadata: [simple-mets1.xml](v2/examples/simple-mets1.xml)

Here is the same digital object expressed with METS 2: [simple-mets2.xml](v2/examples/simple-mets2.xml); note in particular: 
* the change to `<mdSec>` / `<md>`
* the use of `LOCREF` instead of `xlink:href`
* the omission of `<fileGrp>`
* the use of `<structSec>` to map the `<structMap>`

Here is a more complex METS 1 example of a digital object comprising a research data set; note in particular the multiple `<fileGrp>` and `<structMap>` elements: [complex-mets1.xml](v2/examples/complex-mets1.xml)
Expressed in METS 2, the changes are much the same as for the simpler digital object: [complex-mets2.xml](v2/examples/complex-mets2.xml). Note in this case the `<fileGrp>` elements are preserved, and the multiple `<structMap>` elements are nested under `<structSec>`.

## METS Profiles

For METS 1 one important feature has been [METS profiles](https://www.loc.gov/standards/mets/mets-profiles.html). These allow implementors to describe a class of METS documents in sufficient detail to provide both document authors and programmers the guidance they require to create and process METS documents conforming with a particular profile. Profiles describe what METS elements are expected to be present and how they will be used in a particular application. Implementors may register the profile for purposes around re-use or interoperability, or may use profiles primarily for internal documentation.

### METS Profiles for METS 2

There continues to be value in a standard mechanism for documenting usage in METS; it is helpful both for local system documentation as well as for interchange of METS documents. While the existing METS profile schema is not directly machine-actionable, it is possible for Schematron rules or other automated validation to reference documentation in METS profiles expressed in XML.

Thus, we plan to release a new version of the METS profile schema that matches the changes made to METS 2.

## Conclusion and Future Work

As we work through the process of finalizing METS 2, there are a number of remaining tasks. First and foremost, we seek feedback on the draft METS 2 schema. We welcome feedback to the [METS mailing list](https://listserv.loc.gov/cgi-bin/wa?A0=METS). In particular, we are interested in:
* whether the proposed changes here make sense
* if you are a current METS 1 user: whether your use of METS 1 could be migrated to METS 2; if so, what benefits or drawbacks you would see to migrating, assuming uptake in the community
* if you are not a current METS 1 user: if you would consider implementing METS 2; if implementing METS 2 seems more straightforward for your use case
* changes you would be interested in seeing in METS 2 that we have not addressed

In addition to gathering feedback, there are several supporting tools and documents we plan to produce:

### Controlled vocabularies

As mentioned above, we will publish a list of recommended values for the attributes that had enumerated value restrictions in METS 1.

### Sample transformation from METS 1 to METS 2

We plan to produce a sample XSLT transformation to aid in migration from METS 1 to METS 2. This may not meet every need, but it is our goal to produce a transformation that covers most existing METS 1 use cases.

### Updated documentation

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

[^pcdm]: Portland Common Data Model, DuraSpace, 2016. https://pcdm.org/models

[^iiif]: International Image Interoperability Framework. https://iiif.io

[^bagit]: J. Kunze, J. Littman, E. Madden, J. Scancella, C. Adams, "The BagIt File Packaging Format (V1.0)", RFC 8493, 2018. https://www.rfc-editor.org/info/rfc8493

[^ocfl]: A. Hankinson, N. Jefferies, R. Metz, J. Morley, S. Warner, A. Woods, "Oxford Common File Layout Specification 1.0", 2020. https://ocfl.io/1.0/spec/
