import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Bool "mo:base/Bool";

actor Assistant {
  type ToDo = {
    description : Text;
    complated : Bool;
  };

  //Nat = int = natural (doğal sayı)
  //HashMap
  func natHash(n : Nat) : Hash.Hash {
    Text.hash(Nat.toText(n));
  };

  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  public query func getTodos() : async [ToDo] {
    return Iter.toArray(todos.vals());
  };

  //ID ToDo Ataması - sorgu ve tanımlama
  public query func addToDo(description : Text) : async Nat {
    let id = nextId;
    todos.put(id, { description = description; complated = false });
    nextId += 1;
    return id;
  };

  //Update -  complated
  public func complateTodo(id : Nat) : async () {
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(id, { description = description; complated = true });
    };
  };

  public query func showTodos() : async Text {
    var output : Text = "\n______TO-DOs_____\n";
    for (todo : ToDo in todos.vals()) {
      output #= "\n" # todo.description;
      if (todo.complated) {
        output #= "🥳";
      };
    };
    output # "\n";
  };

  public func clearComplated() : async () {
    todos := Map.mapFilter<Nat, ToDo, ToDo>(
      todos,
      Nat.equal,
      natHash,
      func(_, todo) { if (todo.complated) null else ?todo },
    );
  };

};
