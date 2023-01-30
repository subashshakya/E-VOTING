using DPFP;
using DPFP.Capture;
using DPFP.Verification;
using System.Drawing;
using System.Text.RegularExpressions;
using Capture = DPFP.Capture.Capture;
using EventHandler = DPFP.Capture.EventHandler;

namespace EvotingAPI
{
    public interface IBiometric
    {
        void Start();
        void Stop();
    }
    public partial class Biometric : IBiometric,EventHandler
    {
        //private readonly ILogger _logger;
        Capture capturer;

        public DPFP.Capture.Capture Capturer { get; private set; }
        public delegate void OnTemplateEventHandler(DPFP.Template template);
        delegate void Function();   // a simple delegate for marshalling calls from event handlers to the GUI thread
        private DPFP.Verification.Verification Verificator;
        private DPFP.Template Template;


        public Biometric()
        {
            capturer = new DPFP.Capture.Capture();				// Create a capture operation.
            capturer.EventHandler = this;
        }

        public void Start()
		{
            if (null != capturer)
            {
                try
                {
                    capturer.StartCapture();
                    Console.WriteLine("Using the fingerprint reader, scan your fingerprint.");
                }
                catch(Exception ex)
                {
                    Console.WriteLine("Can't initiate capture!");
                }
            }
		}

        public void Stop()
        {
            if (null != capturer)
            {
                try
                {
                    capturer.StopCapture();
                }
                catch
                {
                    SetPrompt("Can't terminate capture!");
                }
            }
        }

        private void SetPrompt(string v)
        {
            throw new NotImplementedException();
        }

        public DPFP.FeatureSet ExtractFeatures(DPFP.Sample Sample, DPFP.Processing.DataPurpose Purpose)
        {
            DPFP.Processing.FeatureExtraction Extractor = new DPFP.Processing.FeatureExtraction();  // Create a feature extractor
            DPFP.Capture.CaptureFeedback feedback = DPFP.Capture.CaptureFeedback.None;
            DPFP.FeatureSet features = new DPFP.FeatureSet();
            Extractor.CreateFeatureSet(Sample, Purpose, ref feedback, ref features);            // TODO: return features as a result?
            if (feedback == DPFP.Capture.CaptureFeedback.Good)
                return features;
            else
                return null;
        }


        public void OnComplete(object Capture, string ReaderSerialNumber, Sample Sample)
        {
            Process(Sample);
            

        }

        public void OnFingerGone(object Capture, string ReaderSerialNumber)
        {
            throw new NotImplementedException();
        }

        public void OnFingerTouch(object Capture, string ReaderSerialNumber)
        {
            Console.WriteLine("Finger Touched");
        }

        public void OnReaderConnect(object Capture, string ReaderSerialNumber)
        {
            throw new NotImplementedException();
        }

        public void OnReaderDisconnect(object Capture, string ReaderSerialNumber)
        {
            throw new NotImplementedException();
        }

        public void OnSampleQuality(object Capture, string ReaderSerialNumber, CaptureFeedback CaptureFeedback)
        {
            throw new NotImplementedException();
        }
        protected Bitmap ConvertSampleToBitmap(DPFP.Sample Sample)
        {
            DPFP.Capture.SampleConversion Convertor = new DPFP.Capture.SampleConversion();  // Create a sample convertor.
            Bitmap bitmap = null;                                                           // TODO: the size doesn't matter
            Convertor.ConvertToPicture(Sample, ref bitmap);                                 // TODO: return bitmap as a result
            return bitmap;
        }
        private void UpdateStatus()
        {
            // Show number of samples needed.
            //_logger.LogInformation(String.Format("Fingerprint samples needed: {0}", Enroller.FeaturesNeeded));
        }
        protected void Process(DPFP.Sample Sample)
        {

            // Process the sample and create a feature set for the enrollment purpose.
            DPFP.FeatureSet features = ExtractFeatures(Sample, DPFP.Processing.DataPurpose.Verification);
            // Check quality of the sample and start verification if it's good
            // TODO: move to a separate task
            if (features != null)
            {
                // Compare the feature set with our template
                using (FileStream fs = File.OpenRead("C:\\Users\\Nitish Raj\\OneDrive\\Desktop\\nitish2.fpt"))
                {
                    DPFP.Template template = new DPFP.Template(fs);
                    //OnTemplate(template);
                    Template = template;

                }
                DPFP.Verification.Verification.Result result = new DPFP.Verification.Verification.Result();
                Verificator = new DPFP.Verification.Verification();		// Create a fingerprint template verificator
                Verificator.Verify(features, Template, ref result);
                //UpdateStatus(result.FARAchieved);
                if (result.Verified)
                    Console.WriteLine("", "The fingerprint was VERIFIED.");
                else
                    Console.WriteLine("The fingerprint was NOT VERIFIED.", " ");
            }
        }
    }
}
