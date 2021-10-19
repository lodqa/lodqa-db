# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create! email: "test.user@loqda.org",
                    root: false,
                    username: "test user",
                    password: "password"

Target.create! name: "Test target",
               description: "This is a example target for test.",
               user_id: user.id,
               parser_url: nil,
               endpoint_url: "http://bio2rdf-mirror.dbcls.jp/sparql",
               graph_uri: "",
               dictionary_url: "http://pubdictionaries.org/find_ids.json?dictionar...",
               max_hop: 3,
               ignore_predicates: %w[http://rdfs.org/ns/void#inDataset http://bio2rdf.org/omim_vocabulary:refers-to http://bio2rdf.org/omim_vocabulary:article http://bio2rdf.org/omim_vocabulary:mapping-method],
               sortal_predicates: %w[http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://www.w3.org/2000/01/rdf-schema#subClassOf],
               sample_queries: [
                 "Which genes are involved in calcium binding?",
                 "What drugs can be used to treat pain?",
                 "Which pathways involve genes that are the targets of drugs that treat pain?",
                 "Which genes are involved in pain diseases?",
                 "Which drug targets are linked to mental disease?"
               ],
               home: "http://targets.lodqa.org/",
               publicity: true,
               pred_dictionary_url: ""
