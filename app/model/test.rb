require('htmlentities')
require('rexml/parsers/pullparser')
require('../lib/common')

require('dm-core')
require('dm-aggregates')
require('dm-serializer')
require('dm-validations')
require('dm-transactions')
require('dm-types')

require('base')
require('content')
require('comment')
require('post')
require('category')

DataMapper.setup(:default, 'mysql://localhost/wishdreamevents?encoding=UTF-8')

#WDE::Model::Post.transaction() do |t|
p = WDE::Model::Post.all().first()
puts([p.title(), p.text()])
p.text = "ada adad ad adads adasd adadad asdasd s fdfg dfgdg dfgdg sfsf wewr weewr sdfsdf sdfsdf wrwre sdfsdf sdfsfwrwer sdfsfsfds sfwrwrsdfsfsd sdfsdf sdfwew"
#p.text = nil
#p.summary = nil
#p = WDE::Model::Post.get(2)
#p.title = "test content adasd ss"
#p.text = "ole"
p.status = :published
#p.updated_by = "teste"

#puts(p.dirty?())
p.save()
#puts(p.content_values().errors().inspect())

#p.text = "new text2"
#p.save()

#p_c = WDE::Model::Comment.new()
#p_c.content = p
#p_c.name = "parent"
#p_c.text = "parent comemnt"
#puts(p_c.save())

#c = p.comments.new()
#c.name = "child"
#c.text = "child comment"
#c.parent = p_c
#c.save()

#ctg = WDE::Model::Category.first(:path => '/blog/')

#ctg.contents.push(p)
#ctg.save()

#puts(p.categories)

#p.categories.push(ctg)
#p.save()