package flashx.funk.ioc {
public class IntHolderProvider implements IProvider {
    private static var created :int;
    public function get () :*
    {
        var holder :IntHolder = new SubSubIntHolder();
        holder.val = ++created
        return holder;
    }
}
}
