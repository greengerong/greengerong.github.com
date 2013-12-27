---
layout: post
title: "CodeDom六--实体类生成示例"
description: "CodeDom六--实体类生成示例"
category: cnblogs
tags: [code,cnblogs]
---
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CodeDom这个东西个人觉得知识点不多，前几个续节写的已差不多了。在这节将演示一个CodeDom示例：
> 
> 数据库实体类的生成。这里先声明在如今的CodeSmith或者是T4模板中实现这些都很简单，并且更实用，在这
> 
> 里只是一个CodeDom示例，为了演示CodeDom。
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在代码中位了简单、简化数据库数据信息的提取，引用了CodeSimth的SchemaExplorer.dll和SchemaExplorer.
> 
> SqlSchemaProvider.dll。可以在Demo中的CodeSimth目录下找到。
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 先贴上代码，需要讲解的东西没有什么：
 
    using System;
    using System.Text;
    using System.Windows.Forms;
    using SchemaExplorer;
    using System.CodeDom;
    using System.CodeDom.Compiler;
    namespace CodeDomDemo
    {
    public partial class Form1 : Form
    {
    public Form1()
    {
    InitializeComponent();
    }
    private void Form1_Load(object sender, EventArgs e)
    {
    IDbSchemaProvider provider = new SqlSchemaProvider();
    string connectionString = System.Configuration.ConfigurationManager.
    ?
    AppSettings["ConnectionString"].ToString();
    if (string.IsNullOrEmpty(connectionString))
    {
    MessageBox.Show(this, "Connection String is requested,in app configuration.",
    ?
    "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
    Application.Exit();
    }
    DatabaseSchema db = new DatabaseSchema(provider, connectionString);
    lboxTables.Items.AddRange(db.Tables.ToArray());
    }
    ?
            public CodeCompileUnit GenTableCompilerUnit(TableSchema item)
    {
    if (item == null)
    throw new ArgumentNullException("item");
    CodeTypeDeclaration tableClass = new CodeTypeDeclaration();
    tableClass.Attributes = MemberAttributes.Public | MemberAttributes.Final;
    tableClass.Name = item.Name;
    ?
                foreach (var col in item.Columns)
    {
    CodeMemberField field = new CodeMemberField(
    ?
    new CodeTypeReference(col.SystemType), "_" + col.Name);
    CodeMemberProperty property = new CodeMemberProperty();
    property.Name = col.Name;
    property.Attributes = MemberAttributes.Public | MemberAttributes.Final;
    property.Type = new CodeTypeReference(col.SystemType);
    property.SetStatements.Add(new CodeAssignStatement(
    ?
    new CodeFieldReferenceExpression(new CodeThisReferenceExpression(),
    field.Name), new CodePropertySetValueReferenceExpression()));
    property.GetStatements.Add(new CodeMethodReturnStatement(
    ?
    new CodeFieldReferenceExpression(new CodeThisReferenceExpression(), field.Name)));
    tableClass.Members.Add(field);
    tableClass.Members.Add(property);
    }
    CodeNamespace nspace = new CodeNamespace(item.Database.Name);
    nspace.Imports.Add(new CodeNamespaceImport("System"));
    nspace.Types.Add(tableClass);
    CodeCompileUnit unit=new CodeCompileUnit();
    unit.Namespaces.Add(nspace);
    return unit;
    }
    public string GenTanleCodeFromCompilerUnit(CodeCompileUnit unit, string language)
    {
    CodeGeneratorOptions option=new CodeGeneratorOptions();
    option.BlankLinesBetweenMembers =true;
    option.BracingStyle ="c";
    option.ElseOnClosing=true;
    option.IndentString="    ";
    StringBuilder sb=new StringBuilder();
    System.IO.StringWriter sw=new System.IO.StringWriter(sb);
    CodeDomProvider.CreateProvider(language).GenerateCodeFromCompileUnit(unit, sw, option);
    sw.Close();
    return sb.ToString();
    }
    ?
            private void lboxTables_SelectedIndexChanged(object sender, EventArgs e)
    {
    int index = lboxTables.SelectedIndex;
    if (index > -1 && index < lboxTables.Items.Count)
    {
    object obj = lboxTables.Items[index];
    if (obj is TableSchema)
    {
    CodeCompileUnit unit= GenTableCompilerUnit(obj as TableSchema);
    string language="c#";
    if(!string.IsNullOrEmpty(this.toolStripComboBox1.Text))
    language=this.toolStripComboBox1.Text;
    string code = GenTanleCodeFromCompilerUnit(unit,language);
    this.rtbCode.Text = code;
    }
    }
    }
    }
    }
    
运行示图:c#图
[![imagec#图](http://images.cnblogs.com/cnblogs_com/whitewolf/WindowsLiveWriter/CodeDom_12400/image_thumb.png "c#图")](http://images.cnblogs.com/cnblogs_com/whitewolf/WindowsLiveWriter/CodeDom_12400/image_2.png) 

 vb图：
 
![imagevb图](http://images.cnblogs.com/cnblogs_com/whitewolf/WindowsLiveWriter/CodeDom_12400/image_thumb_1.png "vb图")

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 代码比较简单界面也做得太简洁了，呵呵导出文件都没有，我觉得没有什么必要讲解的，如果有什么不懂的或者是写的不对

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 不好的，请留言，我会尽快回复。

> [CodeDom代码下载；](http://files.cnblogs.com/whitewolf/CodeDomDemo-GeneratorCode.rar)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/07/08/1773361.html "原文首发")