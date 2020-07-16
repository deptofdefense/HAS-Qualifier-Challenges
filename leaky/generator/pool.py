from threading import Thread
from queue import Queue

class Worker(Thread):
    def __init__(self, tasks):
        Thread.__init__(self)
        self.tasks = tasks
        self.results = []
        self.daemon = True
        self.start()

    def run(self):
        started = False
        while True:
            func, args = self.tasks.get()
            try:
                self.results.append(
                        func(*args)
                    )
            except Exception as e:
                print(e)
            finally:
                self.tasks.task_done()

class ThreadPool:
    def __init__(self, num_threads=4):
        self.tasks = Queue(num_threads)
        self.workers = []
        for _ in range(num_threads):
            self.workers.append( Worker(self.tasks) )
            
    def add_task(self, func, *args):
        self.tasks.put((func, args))

    def map(self, func, args_list):
        for args in args_list:
            self.add_task(func, *args)

    def get_results(self):
        self.tasks.join()
        results = []
        for w in self.workers:
            results.extend(w.results)
            w.results = []
        return results

