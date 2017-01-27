package modules;

import snipe.edit.Vars;

class Once extends snipe.edit.ModuleEdit<ServerVDL>
{
  public function new(s: ServerVDL)
    {
      super(s);
      name = "once";
      exports = [
	  
	  {
          action: "once.list",
          title: "Разовые турниры",
          blocks: [
			{
              type: BLOCK_LIST,
			  title: "Список разовыых турниров",
              actionPre: "once.",
			  actions: [ "edit", "del" ],
              query: "SELECT * " +
                    "FROM tournament WHERE type='once' ORDER BY id",
              fields: [ 'name', 'startdate', 'rounddate', 'roundtime', 'roundinterval' ]
            },
			{
              type: BLOCK_FORM,
              title: "Добавить турнир",
              action: "once.add",
              inputs: [
				{ title: "Наименование турнира", name: "name" },
                { title: "Дата турнира", name: "startdate",
					type: INPUT_DATETIME },
				{ title: "Дата следующего раунда", name: "rounddate",
					type: INPUT_DATETIME },
				{ title: "Длительность раунда", name: "roundtime", type: INPUT_SELECT, 
                  values: [ 
                    { name: "30", value: '30' },
                    { name: "60", value: '60' },
                    { name: "90", value: '90' },
                    ] },
				{ title: "Интервал между раундами", name: "roundinterval", type: INPUT_SELECT, 
                  values: [ 
                    { name: "15", value: '15' },
                    { name: "30", value: '30' },
                    { name: "45", value: '45' },
                ] }
              ]
            }]
      },
	  	{
          action: "once.add",
          isMethod: true,
          back: "once.list"
        },
		 {
          action: "once.del",
          table: "Tournament",
          delete: true,
          back: "once.list"
		},
		{
          action: "once.edit",
          title: "Tournament",
          back: "once.list",
          blocks: [
            {
              type: BLOCK_FORM,
              title: "Tournaments parameters",
              action: "once.update",
              query: "SELECT * FROM Tournament WHERE ID = [id]",
              inputs: [
               { title: "Наименование турнира", name: "name" },
                { title: "Дата турнира", name: "startdate",
					type: INPUT_DATETIME },
				{ title: "Дата следующего раунда", name: "rounddate",
					type: INPUT_DATETIME },
				{ title: "Длительность раунда", name: "roundtime", type: INPUT_SELECT, 
                  values: [ 
                    { name: "30", value: '30' },
                    { name: "60", value: '60' },
                    { name: "90", value: '90' },
                    ] },
				{ title: "Интервал между раундами", name: "roundinterval", type: INPUT_SELECT, 
                  values: [ 
                    { name: "15", value: '15' },
                    { name: "30", value: '30' },
                    { name: "45", value: '45' },
                ] }
              ]
			},
		]
	  },
	  {
          action: "once.update",
          back: "once.list",
          isMethod: true
      },
   ];
  }
  
  function add(vars: Vars)
    {
      var name = server.quote(vars.getString('name'));
      var startdate = vars.getTypedSQL('datetime:startdate').val;
      var rounddate = vars.getTypedSQL('datetime:rounddate').val;
	  var roundtime = vars.getInt('roundtime');
	  var roundinterval = vars.getInt('roundinterval');

      server.query("INSERT INTO Tournament (name, startdate, rounddate, roundtime, roundinterval, type)" +
        "VALUES (" + name + "," + server.quote(startdate) + "," + server.quote(rounddate) + "," + roundtime + "," + roundinterval + "," + server.quote("once") + ")");
    }
	function del(vars: Vars)
    {
      var id = vars.getInt('id');

      server.query("DELETE FROM Tournament WHERE ID = " + id);
    }
	
	 function update(vars: Vars)
    {
      var id = vars.getInt('id');
      var name = server.quote(vars.getString('name'));
      var startdate = vars.getTypedSQL('datetime:startdate').val;
      var rounddate = vars.getTypedSQL('datetime:rounddate').val;
	  var roundtime = vars.getInt('roundtime');
	  var roundinterval = vars.getInt('roundinterval');
		  
      server.query("UPDATE Tournament SET " +
        "name = " + name +
        ", startdate = " + server.quote(startdate) + 
        ", rounddate = " + server.quote(rounddate) + 
		", roundtime = " + roundtime + 
		", roundinterval = " + roundinterval + " WHERE ID = " + id);
    }
	
	
}