using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using REISys.Platform.Legacy.BusinessLogic.AsynchronousTask.BaseTypes;
using REISys.Platform.Legacy.BusinessLogic.AsynchronousTask;
using System.Threading;
using Moq;
using REISys.Platform.AsynchronousTask;
using REISys.ApplicationUtilities.ExceptionManagement;

namespace REISys.Platform.UnitTests.AsynchronousTask
{
    [TestFixture]
    public class ContinuousProcessTests
    {
        ContinuousProcess process;
        Mock<IContinuousProcessTask> taskMock;

        [SetUp]
        public void SetUp() {
            process = new ContinuousProcess(5, TimeSpan.FromMilliseconds(200), Guid.NewGuid());
            taskMock = new Mock<IContinuousProcessTask>();
        }

        [Test]
        public void Execute_HasBeenCalled3Times_After3IntervalsOf200Milliseconds() {
            process.Tasks.Add(taskMock.Object);

            process.Start();
            Thread.Sleep(650);

            taskMock.Verify(t => t.Execute(), Times.Exactly(3));
        }

        [Test]
        public void Start_ThrowsException_IfNoTasksHaveBeenAdded()
        {
            var continuousProcess = new ContinuousProcess(4, TimeSpan.FromSeconds(1), Guid.NewGuid());
            var mockExceptionPublisher = new Mock<IExceptionPublisher>();
            continuousProcess.ExceptionPublisher = mockExceptionPublisher.Object;
            continuousProcess.Start();
            mockExceptionPublisher.Verify(p => p.Publish(It.IsAny<Exception>()));
        }

        [Test]
        public void Execute_AddsErrorToDatabase_WhenTaskThrowsAnException()
        {
            taskMock.Setup(t => t.Execute()).Throws<Exception>();
            var mockDAL = new Mock<IAsynchronousTaskDAL>();
            process.Tasks.Add(taskMock.Object);
            process.AsynchronousTaskDAL = mockDAL.Object;

            process.ExecuteAllTasks();

            mockDAL.Verify(d => d.AddContinuousProcessError(5, It.IsAny<string>(), It.IsAny<string>(), It.IsAny<Guid>()));
        }

        [Test]
        public void Execute_PublishesException_WhenAnErrorHandlerIsGivenAndTaskThrowsAnException()
        {
            var mockExceptionPublisher = new Mock<IExceptionPublisher>();
            taskMock.Setup(t => t.Execute()).Throws<Exception>();
            process.Tasks.Add(taskMock.Object);
            process.ExceptionPublisher = mockExceptionPublisher.Object;
            var errorHandlerMock = new Mock<IContinuousProcessErrorHandler>();
            errorHandlerMock.Setup(h => h.HandleError(It.IsAny<Exception>())).Throws<Exception>();
            process.ErrorHandler = errorHandlerMock.Object;
            var mockDAL = new Mock<IAsynchronousTaskDAL>();
            process.AsynchronousTaskDAL = mockDAL.Object;

            process.ExecuteAllTasks();

            mockExceptionPublisher.Verify(p => p.Publish(It.IsAny<Exception>()));
        }
    }
}
