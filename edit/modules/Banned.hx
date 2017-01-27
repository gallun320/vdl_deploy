package modules;

import snipe.edit.Vars;

class Banned extends snipe.edit.ModuleEdit<ServerVDL>
{
  public function new(s: ServerVDL)
    {
      super(s);
      name = "banned";
      exports = [
	  
	  {
          action: "banned.list",
          title: "Забаненные игроки",
          blocks: [
            {
              type: BLOCK_LIST,
			  title: "Забаненные игроки",
              actionPre: "banned.",
			  actions: [ "edit", "del" ],
              query: "SELECT * " +
                    "FROM users WHERE isbanned = 'true' ORDER BY id",
              fields: [ 'id', 'name', 'email', 'password' ]
            }]
      },
	  {
          action: "banned.del",
          table: "Banned",
          delete: true,
          back: "banned.list"
      },
	{
          action: "banned.edit",
          title: "Banned",
          back: "banned.list",
          blocks: [
            {
              type: BLOCK_FORM,
              title: "Gamers parameters",
              action: "banned.update",
              query: "SELECT name, email FROM users WHERE id = [id]",
              inputs: [
				{ title: "Разбанить пользователя", name: "isbanned", type: INPUT_SELECT, 
                  values: [ 
                    { name: "Нет", value: 'true' },
					{ name: "Да", value: 'false' },
					] 					
				},
				]
			},
		 ]

	},
		
	 {
          action: "banned.update",
          back: "banned.list",
          isMethod: true
     },
   ];
  }
	
	function del(vars: Vars)
    {
      var id = vars.getInt('id');

      server.query("DELETE FROM users WHERE ID = " + id);
    }
	
	 function update(vars: Vars)
    {
		//получаем все данные 
	  var id = vars.getInt('id');
	  var isbanned = server.quote(vars.getString('isbanned'));
	 
      server.query("UPDATE users SET " +
		"isbanned = " + isbanned + " WHERE ID = " + id);
		
	
    }
	
	
}