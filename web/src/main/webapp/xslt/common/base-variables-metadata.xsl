<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  >
  <!-- Global XSL variables about the metadata record. This should be included for
  service dealing with one metadata record (eg. viewing, editing). -->
  
  <xsl:include href="base-variables.xsl"/>
  
  <!-- The metadata record in whatever profile -->
  <xsl:variable name="metadata" select="/root/*[name(.)!='gui' and name(.) != 'request']"/>
  
  <!-- The metadata schema -->
  <xsl:variable name="schema" select="$metadata/gn:info/schema"/>
  <xsl:variable name="metadataUuid" select="$metadata/gn:info/uuid"/>
  <xsl:variable name="metadataId" select="$metadata/gn:info/id"/>
  <xsl:variable name="isTemplate" select="$metadata/gn:info/isTemplate"/>
  
  <!-- The labels, codelists and profiles specific strings -->
  <!-- TODO : label inheritance between profiles - maybe in Java ? -->
  <xsl:variable name="schemaInfo" select="/root/gui/schemas/*[name(.)=$schema]"/>
  <xsl:variable name="labels" select="$schemaInfo/labels"/>
  <xsl:variable name="codelists" select="$schemaInfo/codelists"/>
  <xsl:variable name="strings" select="$schemaInfo/strings"/>

  <xsl:variable name="iso19139schema" select="/root/gui/schemas/iso19139"/>
  <xsl:variable name="iso19139labels" select="$iso19139schema/labels"/>
  <xsl:variable name="iso19139codelists" select="$iso19139schema/codelists"/>
  <xsl:variable name="iso19139strings" select="$iso19139schema/strings"/>
  
  <xsl:variable name="isEditing" select="$service = 'md.edit' or $service = 'md.element.add'"/>
  
  <!-- Display attributes in editor -->
  <xsl:variable name="isDisplayingAttributes" select="/root/request/displayAttributes = 'true'"/>
  
  <xsl:variable name="withInlineEditing" select="false()"/>
  
  <xsl:variable name="withXPath" select="false()"/>
  
  <xsl:variable name="editorConfig">
    <saxon:call-template name="{concat('get-', $schema, '-configuration')}"/>
  </xsl:variable>
  
  <xsl:variable name="iso19139EditorConfig">
    <!-- TODO only load for ISO profiles -->
    <xsl:call-template name="get-iso19139-configuration"/>
  </xsl:variable>
  
  
  <xsl:variable name="tab" select="if (/root/gui/currTab) then /root/gui/currTab else 
    $editorConfig/editor/views/view/tab[@default]/@id"/>
  
  <xsl:variable name="tabConfig" select="$editorConfig/editor/views/view/tab[@id = $tab]"/>
  
  <xsl:variable name="isFlatMode" select="if (/root/request/flat) then /root/request/flat = 'true'
    else $tabConfig/@mode = 'flat'"/>
</xsl:stylesheet>