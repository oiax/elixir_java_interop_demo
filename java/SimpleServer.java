import com.ericsson.otp.erlang.OtpAuthException;
import com.ericsson.otp.erlang.OtpNode;
import com.ericsson.otp.erlang.OtpMbox;
import com.ericsson.otp.erlang.OtpErlangObject;
import com.ericsson.otp.erlang.OtpErlangTuple;
import com.ericsson.otp.erlang.OtpErlangPid;
import com.ericsson.otp.erlang.OtpErlangBinary;
import com.ericsson.otp.erlang.OtpErlangInt;

public class SimpleServer {
  static java.lang.String snode = "simpleserver";
  static java.lang.String mboxname = "mbox";
  static java.lang.String cookie = "elixirjava";
  private OtpNode node;
  private OtpMbox mbox;

  public static void main(String[] args) throws Exception {
    SimpleServer server = new SimpleServer(args);
    server.process();
  }

  public SimpleServer(String[] args) throws java.io.IOException {
    node = new OtpNode(snode, cookie);
    mbox = node.createMbox(mboxname);
    System.err.println("Server started.");
  }

  private void process() throws OtpAuthException {
    while (true) {
      try {
        OtpErlangObject msg = mbox.receive();
        OtpErlangTuple t1 = (OtpErlangTuple) msg;
        OtpErlangPid from = (OtpErlangPid) t1.elementAt(0);
        OtpErlangBinary bin = (OtpErlangBinary) t1.elementAt(1);

        OtpErlangInt reply = new OtpErlangInt(bin.size());
        mbox.send(from, reply);
      }
      catch (Exception e) {
        System.err.println("Error accepting connection: " + e);
      }
    }
  }
}
