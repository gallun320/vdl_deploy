package modules;

import snipe.edit.Vars;

class Price extends snipe.edit.ModuleEdit<ServerVDL>
{
  public function new(s: ServerVDL)
    {
      super(s);
      name = "price";
      exports = [
	  
	  {
          action: "price.list",
          title: "Платные турниры",
          blocks: [
			{
              type: BLOCK_LIST,
			  title: "Список платных турниров",
              actionPre: "price.",
			  actions: [ "edit", "del" ],
              query: "SELECT * " +
                    "FROM tournament WHERE (price>-1) ORDER BY id",
              fields: [ 'name', 'startdate', 'rounddate', 'roundtime', 'roundinterval' ]
            },
			{
              type: BLOCK_FORM,
              title: "Добавить турнир",
              action: "price.add",
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
                ] },
				{ title: "Цена турнира", name: "price" }
              ]
            }]
      },
	  	{
          action: "price.add",
          isMethod: true,
          back: "price.list"
        },
		 {
          action: "price.del",
          table: "Tournament",
          delete: true,
          back: "price.list"
		},
		{
          action: "price.edit",
          title: "Tournament",
          back: "price.list",
          blocks: [
            {
              type: BLOCK_FORM,
              title: "Tournaments parameters",
              action: "price.update",
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
                ] },
				{ title: "Цена турнира", name: "price" }
              ]
			},
		]
	  },
	  {
          action: "price.update",
          back: "price.list",
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
	  var price =  vars.getInt('price');

      server.query("INSERT INTO Tournament (name, startdate, rounddate, roundtime, roundinterval, type, price)" +
        "VALUES (" + name + "," + server.quote(startdate) + "," + server.quote(rounddate) + "," + roundtime + "," + roundinterval + "," + server.quote("once") + "," + price + ")");
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
	  var price =  vars.getInt('price');
		  
      server.query("UPDATE Tournament SET " +
        "name = " + name +
        ", startdate = " + server.quote(startdate) + 
        ", rounddate = " + server.quote(rounddate) + 
		", roundtime = " + roundtime + 
		", roundinterval = " + roundinterval +
		", price = " + price + " WHERE ID = " + id);
    }
	
	
}